# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seed verisi oluşturuluyor..."

# 1. Kullanıcı Oluşturma
puts "👤 Kullanıcılar oluşturuluyor..."
admin = User.find_or_create_by!(email: 'admin@anket.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end
puts "  ✓ Admin kullanıcı oluşturuldu: #{admin.email}"

normal_user = User.find_or_create_by!(email: 'user@anket.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end
puts "  ✓ Normal kullanıcı oluşturuldu: #{normal_user.email}"

# 2. Anket Oluşturma
puts "\n📋 Anketler oluşturuluyor..."
memnuniyet_anketi = Survey.find_or_create_by!(
  user: admin,
  title: 'Memnuniyet Anketi'
) do |survey|
  survey.description = 'Ürün ve hizmetlerimizden memnuniyetinizi ölçmek için hazırlanmış anket.'
  survey.status = :published
end
puts "  ✓ #{memnuniyet_anketi.title} oluşturuldu (Durum: Published)"

geri_bildirim_anketi = Survey.find_or_create_by!(
  user: admin,
  title: 'Geri Bildirim Anketi'
) do |survey|
  survey.description = 'Gelecek sürümler için kullanıcı geri bildirimleri toplama anketi.'
  survey.status = :draft
end
puts "  ✓ #{geri_bildirim_anketi.title} oluşturuldu (Durum: Draft)"

# 3. Soru ve Seçenek Oluşturma
puts "\n❓ Sorular oluşturuluyor..."

# Soru 1: Likert
soru1 = Question.find_or_create_by!(
  survey: memnuniyet_anketi,
  text: 'Ürün kalitesinden memnun kaldınız mı?'
) do |question|
  question.question_type = :likert
end
puts "  ✓ Soru 1 (Likert): #{soru1.text}"

# Soru 2: Çoktan Seçmeli
soru2 = Question.find_or_create_by!(
  survey: memnuniyet_anketi,
  text: 'Hangi özelliğini en çok beğendiniz?'
) do |question|
  question.question_type = :multiple_choice
end
puts "  ✓ Soru 2 (Çoktan Seçmeli): #{soru2.text}"

# Soru 2 için Seçenekler
puts "\n📝 Seçenekler oluşturuluyor..."
option_a = Option.find_or_create_by!(question: soru2, value: 'A') do |option|
  option.text = 'Hız'
end
puts "  ✓ Seçenek A: #{option_a.text}"

option_b = Option.find_or_create_by!(question: soru2, value: 'B') do |option|
  option.text = 'Tasarım'
end
puts "  ✓ Seçenek B: #{option_b.text}"

option_c = Option.find_or_create_by!(question: soru2, value: 'C') do |option|
  option.text = 'Fiyat'
end
puts "  ✓ Seçenek C: #{option_c.text}"

# Soru 3: Serbest Metin
soru3 = Question.find_or_create_by!(
  survey: memnuniyet_anketi,
  text: 'Gelecek için önerileriniz nelerdir?'
) do |question|
  question.question_type = :free_text
end
puts "  ✓ Soru 3 (Serbest Metin): #{soru3.text}"

# 4. Yanıt Oluşturma
puts "\n💬 Kullanıcı yanıtları oluşturuluyor..."

# Likert sorusuna yanıt
response1 = Response.find_or_create_by!(
  user: normal_user,
  survey: memnuniyet_anketi,
  question: soru1
) do |response|
  response.answer_value = '5'
end
puts "  ✓ Yanıt 1: Likert sorusuna '5' yanıtı verildi"

# Çoktan seçmeli soruya yanıt
response2 = Response.find_or_create_by!(
  user: normal_user,
  survey: memnuniyet_anketi,
  question: soru2
) do |response|
  response.answer_value = 'B'
end
puts "  ✓ Yanıt 2: Çoktan seçmeli soruya 'B' (Tasarım) yanıtı verildi"

# Serbest metin sorusuna yanıt
response3 = Response.find_or_create_by!(
  user: normal_user,
  survey: memnuniyet_anketi,
  question: soru3
) do |response|
  response.answer_value = 'Harika bir deneyimdi.'
end
puts "  ✓ Yanıt 3: Serbest metin sorusuna yanıt verildi"

puts "\n✅ Seed verisi başarıyla oluşturuldu!"
puts "\n📊 Özet:"
puts "  • Kullanıcılar: #{User.count}"
puts "  • Anketler: #{Survey.count}"
puts "  • Sorular: #{Question.count}"
puts "  • Seçenekler: #{Option.count}"
puts "  • Yanıtlar: #{Response.count}"
