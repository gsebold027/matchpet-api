# MatchPet API

Esse projeto diz respeito a api do tcc MatchPet.

## Como rodar o projeto
- Você deverá possuir instalado a o ruby 3.1.1 e o postgres
- Para instalar as gems basta rodar o comando:
    `bundle install`
- Agora basta criar os bancos de dados com o comando
    `bin/rails db:create`
- O próximo passo é ajustar as keys do aws e do firebase
    - Firebase: trocar as chaves no arquivo config/matchpet-a1542-firebase-adminsdk-blos5-6c93b7dcaa.json
    - AWS: editar as chaves com o comando `EDITOR="code --wait" bin/rails credentials:edit`
- Rodar as migrations:
    `rails db:migrate`
- Rodar o projeto
    `rails s`

## Estrutura dos diretórios
### /config/
- Arquivos de configuração
- Principais arquivos: 
    - database.yml -> Configuração do banco de dados
    - routes.rb -> Rotas da aplicação
### /db/
- Migrações do projeto
### /app/controllers/
- Classes e funções que são utilizadas pelas Rotas
### /app/models/
- Classes de entidades utilizadas no projeto
