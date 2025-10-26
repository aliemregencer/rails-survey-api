# Frontend Geliştirme Rehberi - Anket Yönetim Sistemi
## GitHub Copilot için Detaylı API Analizi ve Sayfa Spesifikasyonları

---

## 📊 PROJE GENEL BAKIŞ

Bu bir **API-only Ruby on Rails** backend'i için geliştirilecek modern bir frontend uygulamasıdır. Backend `http://localhost:3000` üzerinde çalışmaktadır ve RESTful JSON API sunmaktadır.

**Teknoloji Önerisi:**
- Next.js 14+ (App Router) veya React + Vite
- TypeScript
- Tailwind CSS
- React Query (TanStack Query) - API state management için
- React Hook Form - Form yönetimi için
- Zustand - Global state management için

---

## 🔗 API ENDPOINTS DETAY ANALİZİ

### 1️⃣ **Surveys (Anketler) Endpoint'leri**

#### **GET /api/v1/surveys**
- **Amaç:** Tüm anketleri listele
- **Request:** None
- **Response:**
```json
{
  "surveys": [
    {
      "id": 1,
      "user_id": 1,
      "title": "Memnuniyet Anketi",
      "description": "Ürün ve hizmetlerimizden memnuniyetinizi ölçmek için...",
      "status": 1,
      "created_at": "2025-01-01T12:00:00.000Z",
      "updated_at": "2025-01-01T12:00:00.000Z"
    }
  ]
}
```
- **Status Field Values:** 
  - `0` = "draft" (Taslak)
  - `1` = "published" (Yayında)

#### **GET /api/v1/surveys/:id**
- **Amaç:** Belirli bir anketi getir
- **Request Params:** `id` (URL'de)
- **Response:**
```json
{
  "survey": {
    "id": 1,
    "user_id": 1,
    "title": "Memnuniyet Anketi",
    "description": "Açıklama metni",
    "status": 1,
    "created_at": "2025-01-01T12:00:00.000Z",
    "updated_at": "2025-01-01T12:00:00.000Z"
  }
}
```

#### **POST /api/v1/surveys**
- **Amaç:** Yeni anket oluştur
- **Request Body:**
```json
{
  "survey": {
    "user_id": 1,
    "title": "Yeni Anket",
    "description": "Anket açıklaması",
    "status": "draft"  // veya "published"
  }
}
```
- **Success Response (201):**
```json
{
  "survey": {
    "id": 3,
    "user_id": 1,
    "title": "Yeni Anket",
    "description": "Anket açıklaması",
    "status": 0,
    "created_at": "2025-01-01T12:00:00.000Z",
    "updated_at": "2025-01-01T12:00:00.000Z"
  }
}
```
- **Error Response (422):**
```json
{
  "errors": ["Title can't be blank"]
}
```

#### **PATCH /api/v1/surveys/:id**
- **Amaç:** Anketi güncelle
- **Request Body:**
```json
{
  "survey": {
    "title": "Güncellenmiş Başlık",
    "description": "Güncellenmiş açıklama",
    "status": "published"
  }
}
```
- **Success Response (200):**
```json
{
  "survey": { /* updated survey object */ }
}
```

#### **DELETE /api/v1/surveys/:id**
- **Amaç:** Anketi sil
- **Response (200):**
```json
{
  "message": "Survey deleted successfully"
}
```

---

### 2️⃣ **Questions (Sorular) Endpoint'leri**

#### **GET /api/v1/questions**
- **Amaç:** Tüm soruları listele
- **Response:**
```json
{
  "questions": [
    {
      "id": 1,
      "survey_id": 1,
      "text": "Ürün kalitesinden memnun kaldınız mı?",
      "question_type": 2,  // 0=free_text, 1=multiple_choice, 2=likert
      "created_at": "2025-01-01T12:00:00.000Z",
      "updated_at": "2025-01-01T12:00:00.000Z"
    }
  ]
}
```

#### **GET /api/v1/questions/:id**
- **Amaç:** Belirli bir soruyu getir
- **Response:**
```json
{
  "question": {
    "id": 1,
    "survey_id": 1,
    "text": "Soru metni",
    "question_type": 1,
    "created_at": "2025-01-01T12:00:00.000Z",
    "updated_at": "2025-01-01T12:00:00.000Z"
  }
}
```

**Not:** Questions endpoint'lerinde sadece READ işlemleri var (create/update/delete yok).

---

### 3️⃣ **Responses (Yanıtlar) Endpoint'leri**

#### **GET /api/v1/responses**
- **Amaç:** Tüm yanıtları listele
- **Response:**
```json
{
  "responses": [
    {
      "id": 1,
      "user_id": 2,
      "survey_id": 1,
      "question_id": 1,
      "answer_value": "5",
      "created_at": "2025-01-01T12:00:00.000Z",
      "updated_at": "2025-01-01T12:00:00.000Z"
    }
  ]
}
```

#### **POST /api/v1/responses**
- **Amaç:** Yeni yanıt oluştur
- **Request Body:**
```json
{
  "response": {
    "user_id": 2,
    "survey_id": 1,
    "question_id": 1,
    "answer_value": "5"  // veya "B" veya "Harika bir deneyimdi"
  }
}
```
- **Success Response (201):**
```json
{
  "response": {
    "id": 4,
    "user_id": 2,
    "survey_id": 1,
    "question_id": 1,
    "answer_value": "5",
    "created_at": "2025-01-01T12:00:00.000Z",
    "updated_at": "2025-01-01T12:00:00.000Z"
  }
}
```

---

### 4️⃣ **Health Check**
#### **GET /api/health**
- **Amaç:** API'nin çalışıp çalışmadığını kontrol et
- **Response:** (JSON format)
```json
{
  "status": "ok"
}
```

---

## 🎨 FRONTEND SAYFA SPESİFİKASYONLARI

### **SAYFA 1: Dashboard / Anket Listesi**
**Route:** `/` veya `/dashboard`

**İşlevsellik:**
1. Sayfa yüklendiğinde `GET /api/v1/surveys` çağrısı yap
2. Tüm anketleri kart formatında göster
3. Her kart şu bilgileri içermeli:
   - Anket başlığı (`title`)
   - Açıklama (`description`) - kısaltılmış
   - Durum badge'i (`status`):
     - `status: 0` → "Taslak" (Gri badge)
     - `status: 1` → "Yayında" (Yeşil badge)
   - Oluşturulma tarihi (`created_at`) - formatlanmış
4. Her kart üzerinde:
   - "Düzenle" butonu
   - "Sil" butonu (confirmation dialog ile)
   - "Görüntüle" veya "Yanıt Ver" butonu
5. Sağ üstte "Yeni Anket Oluştur" butonu

**UI Bileşenleri:**
```
DashboardPage
├── PageHeader (Başlık + Yeni Anket Butonu)
├── SurveyGrid veya SurveyList
│   └── SurveyCard (Her bir anket için)
│       ├── SurveyHeader (Başlık + Status Badge)
│       ├── SurveyDescription (Kısaltılmış açıklama)
│       ├── SurveyMeta (Tarih bilgisi)
│       └── SurveyActions (Butonlar: Düzenle, Sil, Görüntüle)
└── EmptyState (Eğer anket yoksa)
```

**API Entegrasyonu:**
```typescript
// useSurveys hook
const { data: surveys, isLoading, error } = useQuery({
  queryKey: ['surveys'],
  queryFn: () => fetch('/api/v1/surveys').then(res => res.json())
});

// Delete mutation
const deleteMutation = useMutation({
  mutationFn: (id: number) => 
    fetch(`/api/v1/surveys/${id}`, { method: 'DELETE' }),
  onSuccess: () => queryClient.invalidateQueries(['surveys'])
});
```

---

### **SAYFA 2: Anket Oluşturma/Düzenleme**
**Route:** `/surveys/new` (create) veya `/surveys/:id/edit` (update)

**İşlevsellik:**
1. Form alanları:
   - **Title** (Zorunlu, text input)
   - **Description** (Zorunlu, textarea)
   - **Status** (Radio buttons veya select):
     - "Taslak" (`draft`)
     - "Yayında" (`published`)
   - **User ID** (Hidden field - şimdilik hardcoded olabilir)

2. Validasyon:
   - Title boş olamaz
   - Description boş olamaz
   - Status seçilmiş olmalı

3. Gönderim:
   - Create: `POST /api/v1/surveys`
   - Update: `PATCH /api/v1/surveys/:id`
   
4. Başarılı olursa:
   - Dashboard'a yönlendir
   - Toast notification göster: "Anket başarıyla oluşturuldu!" / "Anket güncellendi!"

5. Hata durumunda:
   - `422` response'da gelen `errors` array'ini göster
   - Her hata mesajını form altında listele

**UI Bileşenleri:**
```
SurveyFormPage
├── PageHeader (Başlık: "Yeni Anket" veya "Anket Düzenle")
├── Form
│   ├── TextInput (Title - required)
│   ├── Textarea (Description - required)
│   ├── RadioGroup veya Select (Status)
│   └── FormActions
│       ├── Cancel Button (Dashboard'a dön)
│       └── Submit Button ("Kaydet" veya "Oluştur")
└── ErrorMessages (Hata mesajları için)
```

**API Entegrasyonu:**
```typescript
// Create
const createMutation = useMutation({
  mutationFn: (data: SurveyFormData) =>
    fetch('/api/v1/surveys', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ survey: { ...data, user_id: 1 } })
    }),
  onSuccess: () => {
    router.push('/dashboard');
    toast.success('Anket başarıyla oluşturuldu!');
  },
  onError: (error) => {
    // Hata handling
  }
});

// Update
const updateMutation = useMutation({
  mutationFn: ({ id, data }: { id: number, data: SurveyFormData }) =>
    fetch(`/api/v1/surveys/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ survey: data })
    })
});
```

---

### **SAYFA 3: Anket Detay / Sonuçlar**
**Route:** `/surveys/:id` veya `/surveys/:id/results`

**İşlevsellik:**
1. Anket bilgilerini göster:
   - Başlık, açıklama, durum
   - İstatistikler:
     - Toplam yanıt sayısı
     - Oluşturulma tarihi

2. Bu anketteki soruları listele:
   - `GET /api/v1/questions` ile tüm soruları al
   - `survey_id`'ye göre filtrele (frontend'de)
   - Her soru için:
     - Soru metni
     - Soru tipi (Free Text, Multiple Choice, Likert)

3. Bu anketteki yanıtları göster:
   - `GET /api/v1/responses` ile tüm yanıtları al
   - `survey_id`'ye göre filtrele
   - Her soru için yanıtları grupla göster
   - Soru tipine göre görselleştirme:
     - **Likert (question_type: 2):** Yanıtları rakam olarak göster, histogram/bar chart ile
     - **Multiple Choice (question_type: 1):** Her seçeneğin kaç kez seçildiğini göster, pie chart veya bar chart ile
     - **Free Text (question_type: 0):** Tüm yanıtları liste formatında göster

**UI Bileşenleri:**
```
SurveyResultsPage
├── SurveyHeader
│   ├── Title, Description, Status Badge
│   └── SurveyStats (Toplam yanıt sayısı)
├── QuestionsList
│   └── QuestionResultsCard (Her soru için)
│       ├── QuestionHeader (Soru metni + Tipi)
│       ├── QuestionVisualization
│       │   ├── LikertChart (Likert için)
│       │   ├── MultipleChoiceChart (Çoktan seçmeli için)
│       │   └── FreeTextList (Serbest metin için)
│       └── ResponseStats (Yanıt sayısı)
└── BackButton (Dashboard'a dön)
```

**API Entegrasyonu:**
```typescript
const { data: survey } = useQuery(['survey', id], 
  () => fetch(`/api/v1/surveys/${id}`).then(res => res.json())
);

const { data: questions } = useQuery(['questions'], 
  () => fetch('/api/v1/questions').then(res => res.json())
);

const { data: responses } = useQuery(['responses'], 
  () => fetch('/api/v1/responses').then(res => res.json())
);

// Frontend'de filtreleme
const surveyQuestions = questions?.questions?.filter(q => q.survey_id === id);
const surveyResponses = responses?.responses?.filter(r => r.survey_id === id);
```

---

### **SAYFA 4: Anket Doldurma Sayfası**
**Route:** `/surveys/:id/take` veya `/surveys/:id/respond`

**İşlevsellik:**
1. Anket bilgilerini göster (başlık, açıklama)
2. Soruları sırayla göster:
   - Soru tipine göre input render et:
     - **Free Text (0):** `<textarea>`
     - **Multiple Choice (1):** Radio buttons veya dropdown (options backend'den yok ama frontend'de hardcoded olabilir: A, B, C, D, E)
     - **Likert (2):** 1-5 arası radio buttons veya rating component
3. Her soru için zorunlu validasyon (yanıt verilmeden geçilemez)
4. "Yanıtları Gönder" butonu
5. Gönderim:
   - Her soru için ayrı ayrı `POST /api/v1/responses` çağrısı yap
   - veya tüm yanıtları topla, sonra tek seferde gönder
6. Başarılı olursa:
   - Teşekkür mesajı göster
   - Dashboard'a yönlendir

**UI Bileşenleri:**
```
SurveyTakePage
├── SurveyIntro
│   ├── Title
│   └── Description
├── QuestionsForm
│   └── QuestionInputGroup (Her soru için)
│       ├── QuestionLabel
│       ├── QuestionInput (tipine göre)
│       └── ValidationMessage
├── FormActions
│   └── SubmitButton ("Gönder")
└── SuccessModal (Başarılı gönderim sonrası)
```

**API Entegrasyonu:**
```typescript
const submitMutation = useMutation({
  mutationFn: (responses: Array<{
    user_id: number;
    survey_id: number;
    question_id: number;
    answer_value: string;
  }>) => {
    // Her yanıt için ayrı API call
    return Promise.all(
      responses.map(response =>
        fetch('/api/v1/responses', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ response })
        })
      )
    );
  },
  onSuccess: () => {
    toast.success('Anket başarıyla gönderildi!');
    router.push('/dashboard');
  }
});
```

---

## 🎯 KULLANILACAK UI BİLEŞENLERİ

### **Genel Bileşenler:**

1. **Button**
   - Primary button (Mavi arka plan)
   - Secondary button (Beyaz arka plan, border)
   - Danger button (Kırmızı arka plan - silme işlemleri için)
   - Loading state (spinner)

2. **Badge**
   - Status badge'i (Draft: gri, Published: yeşil)

3. **Card**
   - Anket kartları için
   - Shadow, border-radius

4. **Form Components**
   - TextInput (border, focus ring)
   - Textarea (min-height)
   - Radio buttons
   - Select dropdown

5. **Toast Notifications**
   - Success (yeşil)
   - Error (kırmızı)
   - Info (mavi)

6. **Modal/Dialog**
   - Silme onayı için
   - Teşekkür mesajı için

7. **Chart Components** (Recharts veya Chart.js ile)
   - Bar Chart (Likert sonuçları için)
   - Pie Chart (Çoktan seçmeli sonuçlar için)

8. **Loading Spinner**
   - Sayfa yüklenirken
   - API çağrıları sırasında

9. **Empty State**
   - Anket yoksa
   - Sonuç yoksa

10. **Error State**
    - API hataları için
    - 404/500 sayfaları için

---

## 🎨 RENK PALETİ ÖNERİSİ

```css
/* Status Renkleri */
--color-draft: #6B7280 (Gri)
--color-published: #10B981 (Yeşil)

/* Primary Renkler */
--color-primary: #3B82F6 (Mavi)
--color-primary-hover: #2563EB

/* Danger Renkler */
--color-danger: #EF4444 (Kırmızı)

/* Background */
--color-bg: #F9FAFB (Açık Gri)
--color-card-bg: #FFFFFF (Beyaz)

/* Text */
--color-text-primary: #111827 (Koyu Gri)
--color-text-secondary: #6B7280 (Gri)
```

---

## 📱 RESPONSIVE TASARIM

- **Desktop (> 1024px):** Grid layout, 3-4 sütun
- **Tablet (768px - 1024px):** Grid layout, 2 sütun
- **Mobile (< 768px):** Stacked layout, 1 sütun

---

## ⚠️ ÖNEMLİ NOTLAR

1. **Authentication:** Backend'de authentication henüz yok. Şimdilik `user_id: 1` hardcoded olarak kullanılabilir. Gelecekte JWT eklenebilir.

2. **Error Handling:**
   - Tüm API çağrılarında try-catch kullan
   - Network hatalarını yakala ve kullanıcıya göster
   - 422 (validation error) için backend'den gelen errors array'ini göster
   - 404 ve 500 hataları için özel sayfalar

3. **Loading States:**
   - Her async işlem sırasında loading spinner göster
   - Skeleton screens kullan (optional ama iyi UX)

4. **Optimistic Updates:**
   - Anket silme işlemi için optimistic update yap
   - Anket oluşturma için cache invalidation kullan

5. **Form Validation:**
   - Client-side validation ekle (React Hook Form + Zod)
   - Backend validation'ı da göster

6. **Data Filtering:**
   - Questions ve responses tüm listeyi döndürüyor, frontend'de filtreleme yap

---

## 🚀 BAŞLANGIÇ ADIMLARI

1. Proje kurulumu (Next.js veya Vite)
2. API client setup (Axios veya fetch wrapper)
3. React Query setup
4. Router setup (Next.js App Router veya React Router)
5. Tailwind CSS setup
6. Temel layout component'i (Header, Sidebar gibi)
7. İlk sayfayı oluştur (Dashboard)
8. API entegrasyonu yap
9. Test et ve iterasyon yap

---

## 📝 ÖRNEK KOD YAPISI

```
src/
├── app/ (Next.js App Router)
│   ├── page.tsx (Dashboard)
│   ├── surveys/
│   │   ├── new/
│   │   │   └── page.tsx
│   │   ├── [id]/
│   │   │   └── page.tsx
│   │   └── [id]/edit/
│   │       └── page.tsx
├── components/
│   ├── ui/
│   │   ├── Button.tsx
│   │   ├── Card.tsx
│   │   ├── Badge.tsx
│   │   └── Input.tsx
│   ├── surveys/
│   │   ├── SurveyCard.tsx
│   │   ├── SurveyForm.tsx
│   │   └── SurveyResults.tsx
│   └── charts/
│       ├── BarChart.tsx
│       └── PieChart.tsx
├── lib/
│   ├── api.ts (API client)
│   └── utils.ts
├── hooks/
│   ├── useSurveys.ts
│   ├── useSurvey.ts
│   └── useSubmitResponse.ts
└── types/
    └── index.ts (TypeScript types)
```

---

Bu dokümantasyon, frontend geliştirmesine başlamak için gereken tüm bilgileri içermektedir. Her endpoint'in davranışını, her sayfanın içeriğini ve gereksinimlerini detaylı bir şekilde açıklar.
