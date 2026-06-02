# ================================================
# PRÉ-REQUISITO: Kafka rodando localmente
# Download: https://kafka.apache.org/downloads
# Extraia e entre na pasta do Kafka antes de rodar
# ================================================


# ================================================
# 1. INICIAR ZOOKEEPER E KAFKA (terminais separados)
# ================================================

# Terminal 1 — Zookeeper
bin/zookeeper-server-start.sh config/zookeeper.properties

# Terminal 2 — Kafka Broker
bin/kafka-server-start.sh config/server.properties


# ================================================
# 2. CRIAR OS TÓPICOS
# ================================================

# Tópico 1: pedidos
# 3 partições para paralelismo, replicação 1 (ambiente local)
bin/kafka-topics.sh --create \
  --bootstrap-server localhost:9092 \
  --topic pedidos \
  --partitions 3 \
  --replication-factor 1

# Tópico 2: notificacoes
# 2 partições, replicação 1
bin/kafka-topics.sh --create \
  --bootstrap-server localhost:9092 \
  --topic notificacoes \
  --partitions 2 \
  --replication-factor 1

# Verificar tópicos criados
bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# Detalhes dos tópicos
bin/kafka-topics.sh --describe --topic pedidos --bootstrap-server localhost:9092
bin/kafka-topics.sh --describe --topic notificacoes --bootstrap-server localhost:9092


# ================================================
# 3. PRODUZIR MENSAGENS — TÓPICO: pedidos
# ================================================

# Terminal 3 — Producer pedidos
bin/kafka-console-producer.sh \
  --bootstrap-server localhost:9092 \
  --topic pedidos \
  --property "parse.key=true" \
  --property "key.separator=:"

# Digite as mensagens no formato chave:valor, exemplo:
# pedido-1:{"id":1,"produto":"Teclado","valor":299.90}
# pedido-2:{"id":2,"produto":"Mouse","valor":189.90}
# pedido-3:{"id":3,"produto":"Monitor","valor":1199.00}


# ================================================
# 4. PRODUZIR MENSAGENS — TÓPICO: notificacoes
# ================================================

# Terminal 4 — Producer notificacoes
bin/kafka-console-producer.sh \
  --bootstrap-server localhost:9092 \
  --topic notificacoes \
  --property "parse.key=true" \
  --property "key.separator=:"

# Exemplos:
# cliente-1:Seu pedido #1 foi confirmado!
# cliente-2:Seu pedido #2 foi enviado!
# cliente-3:Seu pedido #3 saiu para entrega!


# ================================================
# 5. CONSUMIR MENSAGENS — TÓPICO: pedidos
# ================================================

# Terminal 5 — Consumer pedidos (do início)
bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic pedidos \
  --from-beginning \
  --property "print.key=true" \
  --property "key.separator=:" \
  --group grupo-pedidos


# ================================================
# 6. CONSUMIR MENSAGENS — TÓPICO: notificacoes
# ================================================

# Terminal 6 — Consumer notificacoes (do início)
bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic notificacoes \
  --from-beginning \
  --property "print.key=true" \
  --property "key.separator=:" \
  --group grupo-notificacoes


# ================================================
# 7. VERIFICAR CONSUMER GROUPS
# ================================================

# Listar grupos
bin/kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --list

# Detalhes do grupo (lag, partições, offsets)
bin/kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --describe \
  --group grupo-pedidos


# ================================================
# 8. LIMPAR (opcional)
# ================================================

# Deletar tópicos ao final
bin/kafka-topics.sh --delete --topic pedidos --bootstrap-server localhost:9092
bin/kafka-topics.sh --delete --topic notificacoes --bootstrap-server localhost:9092
