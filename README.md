# README

# Shopping Cart API

API REST para gerenciamento de carrinho de compras de e-commerce.

## 🛠 Tecnologias

- Ruby 3.3.1
- Rails 7.1.3.2
- PostgreSQL 16
- Redis 7.0.15
- Sidekiq
- RSpec

## 📋 Pré-requisitos

- Docker e Docker Compose (recomendado)
- Ou: Ruby, Rails, PostgreSQL e Redis instalados localmente

## 🚀 Como executar

### Com Docker (Recomendado)
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/cart-api.git
cd cart-api

# Inicie os containers
docker-compose up --build

# Em outro terminal, crie o banco e rode as migrations
docker-compose exec web rails db:create db:migrate

# Crie alguns produtos para testar
docker-compose exec web rails console
Product.create(name: "Produto 1", price: 10.99)
Product.create(name: "Produto 2", price: 25.50)
```

### Sem Docker
```bash
# Instale as dependências
bundle install

# Configure o banco
rails db:create db:migrate

# Inicie o Redis (em um terminal)
redis-server

# Inicie o Sidekiq (em outro terminal)
bundle exec sidekiq

# Inicie o Rails (em outro terminal)
bundle exec rails server
```

## 📝 Endpoints

### 1. Adicionar produto ao carrinho
```bash
POST /cart
Content-Type: application/json

{
  "product_id": 1,
  "quantity": 2
}
```

### 2. Listar carrinho atual
```bash
GET /cart
```

### 3. Atualizar quantidade
```bash
POST /cart/add_item
Content-Type: application/json

{
  "product_id": 1,
  "quantity": 3
}
```

### 4. Remover produto
```bash
DELETE /cart/1
```

## 🧪 Testes
```bash
# Rodar todos os testes
bundle exec rspec

# Com detalhes
bundle exec rspec --format documentation

# Com cobertura
bundle exec rspec --format html --out coverage/index.html
```

## 📦 Jobs

O sistema possui um job que roda automaticamente:
- **A cada hora**: marca carrinhos inativos (3h+) como abandonados
- **A cada hora**: remove carrinhos abandonados há mais de 7 dias

## 📄 Licença

Este projeto foi desenvolvido como parte de um desafio técnico.
