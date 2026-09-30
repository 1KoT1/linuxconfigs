#!/usr/bin/env bash
# Переносит папки закрытых Jira-задач из /pbf-group/tasks в /pbf-group/tasks/Архив.
# Требует env JIRA_URL и JIRA_PERSONAL_TOKEN; если их нет в окружении (например, под cron),
# подхватывает из ~/.config/archive_closed_tasks.env.

set -euo pipefail

TASKS_DIR="/pbf-group/tasks"
ARCHIVE_DIR="${TASKS_DIR}/Архив"
ENV_FILE="${HOME}/.config/archive_closed_tasks.env"

if [[ -z "${JIRA_PERSONAL_TOKEN:-}" && -f "$ENV_FILE" ]]; then
    set -a
    source "$ENV_FILE"
    set +a
fi

JIRA_URL="${JIRA_URL:-https://orpo-jira.pbfgroup.ru}"

if [[ -z "${JIRA_PERSONAL_TOKEN:-}" ]]; then
    echo "JIRA_PERSONAL_TOKEN не задан" >&2
    exit 1
fi

mkdir -p "$ARCHIVE_DIR"

for dir in "$TASKS_DIR"/*/; do
    name="$(basename "$dir")"
    key="${name%/}"

    # Пропускаем не-задачи (Архив, Терминалы и т.п.) — берём только каталоги вида PROJECT-123
    if [[ ! "$key" =~ ^[A-Za-z]+-[0-9]+$ ]]; then
        continue
    fi
    if [[ "$dir" == "$ARCHIVE_DIR/" ]]; then
        continue
    fi

    response="$(curl -sk -H "Authorization: Bearer ${JIRA_PERSONAL_TOKEN}" \
        "${JIRA_URL}/rest/api/2/issue/${key}?fields=status")"

    category="$(echo "$response" | jq -r '.fields.status.statusCategory.key // empty')"
    status_name="$(echo "$response" | jq -r '.fields.status.name // empty')"

    if [[ -z "$category" ]]; then
        echo "SKIP  ${key}: не удалось получить статус (${response:0:200})" >&2
        continue
    fi

    if [[ "$category" == "done" ]]; then
        echo "ARCHIVE ${key} (${status_name}) -> ${ARCHIVE_DIR}/"
        mv -n "$dir" "$ARCHIVE_DIR/"
    else
        echo "KEEP    ${key} (${status_name})"
    fi
done
