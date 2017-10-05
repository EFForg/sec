# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

welcome = <<-EOF
<p>Welcome to the Security Education website!</p>

<p>Here you can find training materials for all your
security education needs.</p>

<p><a href="#">I’m lost! Take me back to SSD!</a></p>

<p><a href="#">Training modules</a></p>

<p><a href="#">Being a Trainer - Advice</a></p>

<p><a href="#">Blog</a></p>

<p><a href="#">Enrichment Materials</a></p>
EOF

articles_intro = %(<p>Whether you’re a computer scientist, a community organizer or just a curious person, Security Education’s collection of resources has something for you.</p>)
Homepage.create!(welcome: welcome, articles_intro: articles_intro)

