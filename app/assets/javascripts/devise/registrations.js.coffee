$(document).ready ->
  $('#new_user').validate
    rules:
      "user[password]":
        minlength: 8
      "user[password_confirmation]":
        equalTo: '#user_password'
