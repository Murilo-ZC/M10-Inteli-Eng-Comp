---
sidebar_position: 3
title: Logs em Sistemas
---

import useBaseUrl from '@docusaurus/useBaseUrl';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Introdução ao conceito de Logs

Os logs são registros de eventos que acontecem em um sistema. Eles são utilizados para registrar informações sobre o funcionamento do sistema, permitindo que os desenvolvedores possam monitorar o sistema e identificar possíveis problemas. Bem generico né? Vamos aprofundar um pouco mais.

## Por que Logs são importantes?

Os logs são importantes porque permitem que os desenvolvedores possam monitorar o sistema e identificar possíveis problemas. Eles são úteis para rastrear o comportamento do sistema e identificar possíveis falhas. Além disso, os logs podem ser utilizados para auditoria de sistemas, permitindo que os desenvolvedores possam verificar o que aconteceu em um determinado momento no sistema.

> Calma Murilo, não posso fazer isso utilizando o console.log ou print ou o equivalente em minha linguagem de programação?

Sim, você pode utilizar o console.log ou print para registrar informações no sistema. No entanto, os logs são mais do que simples mensagens de texto. Eles são registros estruturados que contêm informações sobre o evento que aconteceu, como a data e hora em que o evento ocorreu, o nível de gravidade do evento, o componente do sistema que gerou o evento, entre outras informações.

Além disso, utilizar a saída padrão, como o terminal por exemplo, para registrar informações no sistema pode não ser a melhor prática. Isso porque as mensagens de log podem ser perdidas se o sistema travar ou se o terminal for fechado. Por isso, é importante utilizar um sistema de logs que seja capaz de armazenar as mensagens de log de forma segura e confiável.

## Níveis de Logs

Os logs podem ser classificados em diferentes níveis de gravidade, que indicam a importância do evento que está sendo registrado. Os níveis de logs mais comuns são:

- **DEBUG**: Utilizado para mensagens de depuração, que são úteis para identificar problemas no sistema.
- **INFO**: Utilizado para mensagens informativas, que indicam o funcionamento normal do sistema.
- **WARNING**: Utilizado para mensagens de aviso, que indicam possíveis problemas no sistema.
- **ERROR**: Utilizado para mensagens de erro, que indicam falhas no sistema.
- **CRITICAL**: Utilizado para mensagens críticas, que indicam falhas graves no sistema.

Nem todos os sistemas utilizam os mesmos níveis de logs, e é importante definir quais são os níveis de logs que serão utilizados no sistema. Além disso, é importante utilizar os níveis de logs de forma consistente, para que os desenvolvedores possam interpretar corretamente as mensagens de log.

Recomendo a leitura dos artigos abaixo para aprofundar mais sobre o assunto (eles estão listados nos autoestudos recomendados para este encontro):

- [See everything in your tech stack with these logging best practices](https://newrelic.com/blog/best-practices/best-log-management-practices)
- [SYSTEM LOGGING BEST PRACTICES](https://www.mezmo.com/learn-log-management/system-logging-best-practices)

Nas próximas seções, vamos implementar o sistema de logs em um sistema desenvolvido com o FastAPI. 