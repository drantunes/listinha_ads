# listinhax

Projeto Flutter organizado com arquitetura MVVM.

## Estrutura

```
lib/
  app/
    core/
    data/
      repositories/
    domain/
      models/
    features/
      cart_items/
        viewmodels/
        views/
      products/
        viewmodels/
        views/
```

## Camadas

- `View`: telas (`views`) responsáveis por renderizar estado e disparar eventos.
- `ViewModel`: classes `ChangeNotifier` que concentram estado de apresentação e regras de interação.
- `Model/Repository`: modelos de domínio em `domain/models` e acesso a dados em `data/repositories`.
