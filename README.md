# Profile Indexer Api
Interface de aplicação para solução do [desafio](https://github.com/Fretadao/challenge/tree/master/fullstack/indexer) proposto pelo [Fretadão](https://fretadao.com/)

Para que seja utilizado em sua plenitude deve-se rodar a [aplicação desenvolvida para visualização](#) juntamente a essa aplicação. 

## Summary
 - [Rodando a aplicação](#run)
 - [Endpoints](#endpoints)
    - [Listar/pesquisar perfis](#list-profiles)
    - [Criar perfil](#create-profile)
    - [Recuperar perfil](#get-profile)
    - [Atualizar perfil](#update-profile)
    - [Deletar perfil](#delete-profile)
- [Tecnologias e comentários](#tecnologias-e-comentários)
    - [Sobre o Ruby on Rails](#sobre-o-ruby-on-rails)
    - [Sobre a arquitetura](#sobre-a-arquitetura)
    - [Validações e pesquisa](#validações-e-pesquisa)


## Run
Esta aplicação tem um arquivo [docker](https://www.docker.com/get-started) e docker-compose

Para iniciar faça os seguintes comandos na pasta da aplicação através do *terminal* ou *powershell*:

```
docker build --rm -f "Dockerfile" -t fretadao:latest .
```

e então:


```
docker-compose -f "docker-compose.yml" up -d --build
```

por fim, para migrar o banco de dados:

```
docker-compose run web rake db:migrate
```

## Endpoints
toda aplicação foi modelada em cima de um **modelo único** chamado *Profile*
### List Profiles
Para listar perfis faça a requisição **GET** para *http://localhost:8080/api/v1/profiles* podendo passar um parametro opcional *search* com uma *string* contendo palavras chaves a serem pesquisadas

Exemplo:
```
curl -X GET http://localhost:8080/api/v1/profiles?search=Raul%20coan
```

A resposta esperada será um JSON no seguinte formato:
```
{
    "profiles":[
        {
            "id": 1,
            "name": "Raul coan",
            "twitter_url": "https://twitter.com/TiranoCoan",
            "twitter_username": "@TiranoCoan",
            "twitter_description": "Chasing the wind",
            "created_at": "2019-05-01T19:04:32.486Z",
            "updated_at": "2019-05-01T19:04:32.486Z"
        }
    ]
}
```


### Create Profile
Para criar um novo perfil faça a requisição **POST** para *http://localhost:8080/api/v1/profiles* passando um JSON no formato:
```
{
    "name":"Raul Coan",
    "twitter_url": "https://twitter.com/TiranoCoan"
}
```
Exemplo:
```
curl -X POST http://localhost:8080/api/v1/profiles -H 'content-type: application/json' -d '{"name":"Raul Coan","twitter_url": "https://twitter.com/TiranoCoan"}'
```

A resposta esperada será um JSON no seguinte formato:
```
{
    "id": 1,
    "name": "Raul coan",
    "twitter_url": "https://twitter.com/TiranoCoan",
    "twitter_username": null,
    "twitter_description": null,
    "created_at": "2019-05-01T19:04:32.486Z",
    "updated_at": "2019-05-01T19:04:32.486Z"
}
```

### Get Profile
Para recuperar um perfil especifico faça a requisição **GET** para *http://localhost:8080/api/v1/profiles/{id}* 

Exemplo:
```
curl -X GET http://localhost:8080/api/v1/profiles/{id}
```

A resposta esperada será um JSON no seguinte formato:
```
{
"profile":
    {
        "id": 1,
        "name": "Raul coan",
        "twitter_url": "https://twitter.com/TiranoCoan",
        "twitter_username": null,
        "twitter_description": null,
        "created_at": "2019-05-01T19:04:32.486Z",
        "updated_at": "2019-05-01T19:04:32.486Z"
    }
}
```

### Update Profile
Para atualizar um perfil especifico faça a requisição **PUT** ou **PATCH** para *http://localhost:8080/api/v1/profiles/{id}* passando um JSON no formato:

```
{
    "name": "Raul coan",
    "twitter_url": "https://twitter.com/TiranoCoan",
    "twitter_username": "@TiranoCoan",
    "twitter_description": "Chasing the wind"
}
```
Exemplo:
```
curl -X PUT http://localhost:8080/api/v1/profiles/1 -H 'content-type: application/json' -d '{"name":"Raul Coan","twitter_url": "https://twitter.com/TiranoCoan", "twitter_username": "@TiranoCoan", "twitter_description": "Chasing the wind"}'
```

A resposta esperada será um *200 - success* com um JSON no formato padrão: 
```
{
"profile":
    {
        "id": 1,
        "name": "Raul coan",
        "twitter_url": "https://twitter.com/TiranoCoan",
        "twitter_username": "@TiranoCoan",
        "twitter_description": "Chasing the wind",
        "created_at": "2019-05-01T19:04:32.486Z",
        "updated_at": "2019-05-01T19:04:32.486Z"
    }
}
```
### Delete Profile
Para deletar um perfil especifico faça a requisição **DELETE** para *http://localhost:8080/api/v1/profiles/{id}*

Exemplo:
```
curl -X DELETE http://localhost:8080/api/v1/profiles/{id}
```
A resposta esperada será um *204 - no content*.

## Tecnologias e comentários
### Sobre o Ruby on Rails
O projeto foi desenvolvido utilizando Ruby 2.6 e Rails 5.0 principalmente por questões de praticidade no desenvolvimento do teste, já que esta é a versão mais atual do Ruby no Docker

### Sobre a arquitetura
Decidi utilizar essa arquitetura com uma API e uma view em React.js por se aproximar do que a Fretadão está utilizando e que considero que será utilizada por bastante tempo graças a seus beneficios lidando com aplicativo mobile e web simultaneamente, além da escalabilidade.

O padrão de URL's está *REST-like* com namespaces para rota de API e versão da mesma, para facilitar a manutenção em caso de atualização de regras de negocio ou até mesmo uma migração de tecnologia.

E também está sendo utilizado o **PostgreSQL** por ser uma técnologia que tem boa robustes e permite utilizar o JsonB para realizar *buscas*, apesar que o ideal seria realiza-las com *Elastic*

### Validações e pesquisa
Para realizar as validações de campos decidi utilizar o recurso **[Validates](https://guides.rubyonrails.org/active_record_validations.html)** do rails, parametrizando todas validações para cada campo e este recurso trata de validar para todas ações que persistem dados no banco e também fornece o método **.valid?** para verificar e o atributo **.errors** para retornar mensagens ao usuário de forma prática e segura.

Já a pesquisa foi feita utilizando **[Escopos](https://api.rubyonrails.org/classes/ActiveRecord/Scoping/Named/ClassMethods.html)**, o que não é o ideal por não ser escalavel mas resolve o problema surgerido deixando fácil para que seja implementado de uma nova forma sem gerar muito esforço para compreender e dar manutenção.