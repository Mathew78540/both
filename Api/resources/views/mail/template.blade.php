<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Both</title>
</head>
<body>
Bonjour {{$user->name}}, <br>

Afin de pouvoir vous connecter sur Both, vous devez activer votre compte. Pour ça cliquez sur ce : <a href="http://localhost:8000/api/auth/activation/{{$user->id}}/{{$user->activation_token}}">lien</a>
</body>
</html>