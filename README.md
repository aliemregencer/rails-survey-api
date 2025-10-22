# 📋 Ruby on Rails Anket API'si

Modern ve ölçeklenebilir bir anket yönetim sistemi için geliştirilmiş **API-Only** Ruby on Rails uygulaması.

---

## 📝 Proje Özeti

Bu proje, kullanıcıların anketler oluşturmasına, sorular eklemesine ve yanıtlar toplamasına olanak tanıyan bir REST API'sidir. API-Only modunda geliştirilmiş olması sayesinde:

- **Frontend Bağımsızlığı**: React, Vue.js, React Native gibi herhangi bir frontend framework ile entegre edilebilir
- **Performans**: Gereksiz view rendering ve asset pipeline olmadan daha hızlı çalışır
- **Mikroservis Mimarisi**: Kolayca diğer servislerle entegre edilebilir
- **Mobil Uygulamalar**: iOS ve Android uygulamaları için hazır API altyapısı

---

## 🚀 Teknolojiler

Bu projede kullanılan teknolojiler:

- **Ruby** 3.3.4
- **Ruby on Rails** 8.0.3 (API-Only Mode)
- **SQLite3** (Veritabanı)
- **BCrypt** (Şifre Güvenliği)
- **Puma** (Web Server)

---

## 📦 Kurulum

Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları izleyin:

### 1️⃣ Gereksinimler

- Ruby 3.3.4 veya üzeri
- Rails 8.0.3
- SQLite3

### 2️⃣ Projeyi Klonlayın

```bash
git clone <repository-url>
cd final_api_app
```

### 3️⃣ Bağımlılıkları Yükleyin

```bash
bundle install
```

### 4️⃣ Veritabanını Oluşturun

```bash
rails db:create
```

### 5️⃣ Migration'ları Çalıştırın

```bash
rails db:migrate
```

### 6️⃣ Test Verilerini Yükleyin

```bash
rails db:seed
```

Bu komut örnek kullanıcılar, anketler, sorular ve yanıtlar oluşturacaktır:
- **2 Kullanıcı**: `admin@anket.com` ve `user@anket.com` (şifre: `password`)
- **2 Anket**: Memnuniyet Anketi (Published), Geri Bildirim Anketi (Draft)
- **3 Soru**: Likert, Çoktan Seçmeli, Serbest Metin
- **3 Yanıt**: Örnek kullanıcı yanıtları

### 7️⃣ Sunucuyu Başlatın

```bash
rails server
```

Uygulama `http://localhost:3000` adresinde çalışacaktır.

---

## 🌐 API Endpoint'leri

### **Surveys (Anketler)**

| Metod  | Endpoint                | Açıklama                      |
|--------|-------------------------|-------------------------------|
| GET    | `/api/v1/surveys`       | Tüm anketleri listeler        |
| POST   | `/api/v1/surveys`       | Yeni anket oluşturur          |
| GET    | `/api/v1/surveys/:id`   | Belirli bir anketi gösterir   |
| PATCH  | `/api/v1/surveys/:id`   | Anketi günceller              |
| DELETE | `/api/v1/surveys/:id`   | Anketi siler                  |

**Örnek İstek (POST):**
```bash
curl -X POST http://localhost:3000/api/v1/surveys \
  -H "Content-Type: application/json" \
  -d '{
    "survey": {
      "user_id": 1,
      "title": "Yeni Anket",
      "description": "Açıklama",
      "status": 0
    }
  }'
```

### **Questions (Sorular)**

| Metod  | Endpoint                  | Açıklama                      |
|--------|---------------------------|-------------------------------|
| GET    | `/api/v1/questions`       | Tüm soruları listeler         |
| GET    | `/api/v1/questions/:id`   | Belirli bir soruyu gösterir   |

**Örnek İstek (GET):**
```bash
curl http://localhost:3000/api/v1/questions
```

### **Responses (Yanıtlar)**

| Metod  | Endpoint                | Açıklama                      |
|--------|-------------------------|-------------------------------|
| GET    | `/api/v1/responses`     | Tüm yanıtları listeler        |
| POST   | `/api/v1/responses`     | Yeni yanıt oluşturur          |

**Örnek İstek (POST):**
```bash
curl -X POST http://localhost:3000/api/v1/responses \
  -H "Content-Type: application/json" \
  -d '{
    "response": {
      "user_id": 2,
      "survey_id": 1,
      "question_id": 1,
      "answer_value": "5"
    }
  }'
```

---

## 🗄️ Veritabanı Modelleri

Proje 5 ana model içermektedir:

### **1. User (Kullanıcı)**
```ruby
# Alanlar: email, password_digest
has_many :surveys
has_many :responses
```
- Kullanıcı kimlik doğrulaması için `has_secure_password` kullanır
- Anketlerin ve yanıtların sahibidir

### **2. Survey (Anket)**
```ruby
# Alanlar: user_id, title, description, status
belongs_to :user
has_many :questions
has_many :responses
enum :status, { draft: 0, published: 1 }
```
- Bir kullanıcıya aittir
- Birden fazla soru ve yanıt içerebilir
- Status: Draft (0) veya Published (1)

### **3. Question (Soru)**
```ruby
# Alanlar: survey_id, text, question_type
belongs_to :survey
has_many :options
has_many :responses
enum :question_type, { free_text: 0, multiple_choice: 1, likert: 2 }
```
- Bir ankete aittir
- Birden fazla seçenek içerebilir
- Question Type: Free Text (0), Multiple Choice (1), Likert (2)

### **4. Option (Seçenek)**
```ruby
# Alanlar: question_id, text, value
belongs_to :question
```
- Çoktan seçmeli sorular için kullanılır
- Bir soruya aittir

### **5. Response (Yanıt)**
```ruby
# Alanlar: user_id, survey_id, question_id, answer_value
belongs_to :user
belongs_to :survey
belongs_to :question
```
- Kullanıcıların sorulara verdiği yanıtları saklar
- Hem kullanıcıya, hem ankete, hem de soruya bağlıdır

---

## 📊 Model İlişkileri (ERD)

```
User (1) ----< (N) Survey
  |                  |
  |                  |
(N)                (N)
  |                  |
  |                  |
Response         Question (1) ----< (N) Option
  |                  |
  |                  |
  +------------------+
```

**İlişki Açıklaması:**
- Bir kullanıcı birden fazla anket oluşturabilir
- Bir anket birden fazla soru içerebilir
- Bir soru birden fazla seçenek içerebilir (çoktan seçmeli için)
- Bir kullanıcı birden fazla ankete yanıt verebilir
- Her yanıt bir kullanıcı, bir anket ve bir soruya bağlıdır

---

## 🧪 Test

Seed verilerini yükledikten sonra API'yi test etmek için:

```bash
# Tüm anketleri listele
curl http://localhost:3000/api/v1/surveys

# Belirli bir anketi göster
curl http://localhost:3000/api/v1/surveys/1

# Tüm soruları listele
curl http://localhost:3000/api/v1/questions

# Tüm yanıtları listele
curl http://localhost:3000/api/v1/responses
```

**Postman veya Insomnia** gibi API test araçları da kullanılabilir.

---

## 🔐 Güvenlik

- Kullanıcı şifreleri `bcrypt` gem'i ile hashlenmiş olarak saklanır
- Strong Parameters ile parametre güvenliği sağlanır
- Foreign Key constraints ile veri bütünlüğü korunur

---

## 📚 Öğrenme Kaynakları

- [Rails API-Only Uygulamaları](https://guides.rubyonrails.org/api_app.html)
- [Active Record İlişkileri](https://guides.rubyonrails.org/association_basics.html)
- [Rails Routing Guide](https://guides.rubyonrails.org/routing.html)

---

## 👨‍💻 Geliştirici

Bu proje, Ruby on Rails 8 öğrenme amaçlı geliştirilmiş bir öğrenci projesidir.

---

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir.

---

**Not**: Üretim ortamına almadan önce PostgreSQL gibi bir veritabanına geçiş yapılması ve authentication/authorization sistemi eklenmesi önerilir.
