# Changelog

Все изменения этого проекта документированы в этом файле.

## [Unreleased]

### Добавлено
- Обязательное подтверждение email при регистрации
- Красивые ячейки для ввода кода верификации
- Улучшенный диалог обновления с отображением changelog

### Исправлено
- Выход после пропуска авторизации
- Сборка Docker (.env из build-args)
- Предупреждения анализатора

## Как использовать

### Вариант 1: Передать changelog через build-arg

В GitHub Actions (deploy.yml):
```yaml
- name: Получить последние изменения
  id: changelog
  run: |
    # Берем изменения из последнего коммита или changelog файла
    CHANGELOG=$(git log -1 --pretty=%B | head -n 5 | tr '\n' '\\n')
    echo "changelog=$CHANGELOG" >> $GITHUB_OUTPUT

- name: Сборка Docker образа
  uses: docker/build-push-action@v5
  with:
    build-args: |
      GIT_COMMIT=${{ github.sha }}
      CHANGELOG=${{ steps.changelog.outputs.changelog }}
```

### Вариант 2: Использовать тег релиза

```yaml
- name: Получить changelog из тега
  if: startsWith(github.ref, 'refs/tags/')
  run: |
    VERSION=${GITHUB_REF#refs/tags/}
    CHANGELOG=$(git tag -l --format='%(contents)' $VERSION)
    echo "CHANGELOG=$CHANGELOG" >> $GITHUB_ENV
```

### Вариант 3: Хранить в CHANGELOG.md

Структура:
```markdown
## [1.2.0] - 2025-01-15

- Новая функция X
- Исправлена ошибка Y
- Улучшена производительность Z
```

Затем парсить в CI/CD и передавать в Docker.
