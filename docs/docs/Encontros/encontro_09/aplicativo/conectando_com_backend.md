---
sidebar_position: 5
title: Conversando com o Backend
---

import useBaseUrl from '@docusaurus/useBaseUrl';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Comunicação com o Backend

Pessoal para essa etapa do nosso projeto, vamos trabalhar com a comunicação entre o aplicativo e o backend. Essa implementação precisa do uso de uma biblioteca chamada `http` que é responsável por fazer requisições HTTP. Mas não apenas isso, também vamos precisar do nosso backend funcionando. Pode ser a `versão 1` do nosso backend, que é a mais simples e que já está disponível no repositório do projeto.

:::note[Checkpoint do Aplicativo]

Pessoal existem duas versões do aplicativo no repositório. Durante o encontro, vamos continuar com a versão `checkpoint` que é a versão do aplicativo desenvolvida até esse momento.

:::

## Requisições HTTP

Para fazer requisições HTTP no Flutter, vamos utilizar a biblioteca `http`. Para adicionar essa biblioteca ao nosso projeto, vamos adicionar a seguinte dependência no arquivo `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1
```
Agora vamos fazer uma requisição HTTP para o nosso backend. Para isso, vamos configurar a ação do botão '😁' para que ele faça a operação do botão `=`, mas enviando ela para o servidor.
