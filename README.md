# Basset VN

Bot do Discord para criação e execução de *visual novels*.

## VN-SCRIPT
O projeto tem como objetivo usar uma linguagem própria para criação de *visual novels*, seguindo o exemplo abaixo:


add_image 'História de exemplo' mateus_muito_triste wfjiawjfoajif.com

```ruby
História de exemplo

1
[mateus_muito_triste](Mateus)Estou muito triste. O que eu faço?
Ir pra casa,#2a
Chorar,#2b,tristeza++
Fazer nada,#2c

2a
(Mateus)[mateus_muito_triste]Vou dormir agora que cheguei em casa.
()Mateus dormiu por algumas horas
(Mateus) [mateus_muito_triste] Já sei, vou sair de casa!!
#1

 2b
(Mateus)BUÁ BUÁ
(Cachorro do Mateus)PARE DE CHORAR HUMANO
(Mateus)?
()Mateus estava confuso porque o cachorro começou a falar
Fazer nada,#2c

 2c
-- comentário
(Mateus)...
()...
if tristeza>0
  (Mateus)Talvez seja melhor se eu ficar feliz
  %feliz%
else
  (Mateus)Não tenho propósito na vida.
  Fazer nada,#2c
end

%feliz%Final feliz.
```


## SETUP

Criar .env

```bash
cp .env{.example,}
```

## EXECUÇÃO

```bash
docker compose up
```

