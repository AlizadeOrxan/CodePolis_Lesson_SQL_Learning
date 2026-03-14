# 🗄️ SQL & Relational Databases — Tam Ders Materiali

> **Səviyyə:** Başlanğıcdan Orta səviyyəyə
> **Mövzular:** DDL · DML · DCL · TCL · SELECT · JOINs · Aggregate Functions
> **Verilənlər Bazası:** PostgreSQL / MySQL uyğun sintaksis

---

# 📚 Mündəricat

1. [Verilənlər Bazasının Əsasları](#1-verilənlər-bazasının-əsasları)
2. [Məlumat Tipləri (Data Types)](#2-məlumat-tipləri)
3. [Kontrantlar (Constraints)](#3-kontrantlar-constraints)
4. [DDL — Struktur İdarəetməsi](#4-ddl--struktur-idarəetməsi)
5. [DML — Məlumat İdarəetməsi](#5-dml--məlumat-idarəetməsi)
6. [DCL — İcazə İdarəetməsi](#6-dcl--icazə-idarəetməsi)
7. [TCL — Transaksiya İdarəetməsi](#7-tcl--transaksiya-idarəetməsi)
8. [SELECT — Məlumat Oxumaq](#8-select--məlumat-oxumaq)
9. [Aqreqat Funksiyalar & GROUP BY & HAVING](#9-aqreqat-funksiyalar--group-by--having)
10. [SQL JOINs — Cədvəllərin Birləşdirilməsi](#10-sql-joins--cədvəllərin-birləşdirilməsi)
11. [Master Tips & Best Practices](#11-master-tips--best-practices)

---

# 1. Verilənlər Bazasının Əsasları

## 💡 Nəzəriyyə

**Verilənlər Bazası (Database)** — məlumatların məntiqi və strukturlaşdırılmış şəkildə saxlandığı, idarə olunduğu sistemdir.

**RDBMS (Relational Database Management System)** — məlumatları bir-biri ilə əlaqəli **cədvəllər** vasitəsilə saxlayan sistemdir.

> 📌 **Analogiya:** Verilənlər bazasını bir kitabxana, cədvəlləri isə kitabxanadakı rəflər kimi düşünün. Hər layihə üçün ayrı "kitabxana" (database) yaratmaq lazımdır.

## 🏗️ Əsas Strukturlar

| Struktur | Təsvir | Nümunə |
|---|---|---|
| **Database** | Cədvəlləri özündə saxlayan konteyner | `UniversityDB` |
| **Table (Cədvəl)** | Məlumatların saxlandığı əsas obyekt | `Students`, `Employees` |
| **Row / Record (Sətir)** | Bir obyektə aid tam məlumat toplusu | Bir tələbənin bütün məlumatı |
| **Column / Field (Sütun)** | Spesifik bir məlumat növü | `FirstName`, `Salary` |

---

# 2. Məlumat Tipləri

## 💡 Nəzəriyyə

Hər sütun, hansı növ məlumat saxlayacağını müəyyən edən bir **Data Type**-a malik olmalıdır. Yanlış tip seçimi həm performans, həm də məlumat bütövlüyü problemlərinə yol aça bilər.

## 📋 Əsas Data Tiplər

| Tip | Təsvir | Nümunə İstifadə |
|---|---|---|
| `INTEGER` / `INT` | Tam ədədlər | `EmployeeID`, `Age` |
| `VARCHAR(n)` | Maks `n` simvola qədər mətn | `FirstName VARCHAR(50)` |
| `TEXT` | Limitsiz uzunluqlu mətn | Uzun şərhlər, açıqlamalar |
| `NUMERIC` / `DECIMAL(p,s)` | Kəsr ədədlər (dəqiq hesablamalar) | `Salary DECIMAL(10,2)` |
| `DATE` | Tarix (`YYYY-MM-DD`) | `HireDate`, `BirthDate` |
| `BOOLEAN` | Yalnız `TRUE` ya `FALSE` | `IsActive` |
| `SERIAL` | Avtomatik artan tam ədəd (PostgreSQL) | `ProductID SERIAL` |

```sql
-- Nümunə: Müxtəlif data tiplərinin istifadəsi
CREATE TABLE Employees (
    EmployeeID   SERIAL,             -- Avtomatik artan ID (PostgreSQL)
    FirstName    VARCHAR(50),        -- Maks 50 simvol
    Notes        TEXT,               -- Limitsiz mətn
    Salary       DECIMAL(10, 2),     -- 10 rəqəm, 2 kəsr (məs: 55000.75)
    HireDate     DATE,               -- Tarix formatı: 2024-01-15
    IsActive     BOOLEAN             -- TRUE / FALSE
);
```

---

# 3. Kontrantlar (Constraints)

## 💡 Nəzəriyyə

Kontrantlar cədvəldəki məlumatların **düzgünlüyünü**, **etibarlılığını** və **əlaqəliliyini** təmin edən qaydalardır. Onlar məlumat daxil edilərkən avtomatik olaraq yoxlanılır.

## 📋 Kontrant Növləri

| Kontrant | Məqsəd | Xüsusiyyət |
|---|---|---|
| `PRIMARY KEY` | Hər sətri unikal şəkildə müəyyən edir | `NOT NULL` + `UNIQUE` birlikdə. Cədvəldə yalnız **bir** ola bilər |
| `FOREIGN KEY` | İki cədvəl arasında əlaqə yaradır | Referensial bütövlüyü qoruyur |
| `NOT NULL` | Sütunun boş qala bilməməsini təmin edir | Mütləq doldurulmalıdır |
| `UNIQUE` | Sütundakı bütün dəyərlərin fərqli olmasını təmin edir | `NULL` ola bilər |
| `CHECK` | Sütuna xüsusi şərt qoyur | Məs: `Salary > 0` |
| `DEFAULT` | Dəyər daxil edilmədikdə standart dəyər təyin edir | Məs: `DEFAULT TRUE` |

```sql
-- Nümunə: Bütün kontrantların bir cədvəldə istifadəsi
CREATE TABLE Employees (
    EmployeeID   SERIAL         PRIMARY KEY,        -- Unikal, boş ola bilməz
    FirstName    VARCHAR(50)    NOT NULL,            -- Mütləq daxil edilməlidir
    Email        VARCHAR(100)   UNIQUE,              -- Hər email fərqli olmalıdır
    Salary       DECIMAL(10,2)  CHECK (Salary > 0), -- Maaş mütləq müsbət olmalıdır
    IsActive     BOOLEAN        DEFAULT TRUE,        -- Standart dəyər: aktiv
    DepartmentID INT            REFERENCES Departments(DepartmentID) -- FK əlaqəsi
);
```

> ⚠️ **Vacib:** `FOREIGN KEY` təyin etdiyiniz sütunun dəyəri mütləq istinad etdiyi cədvəlin `PRIMARY KEY` sütununda mövcud olmalıdır. Əks halda xəta alırsınız.

---

# 4. DDL — Struktur İdarəetməsi

> **DDL = Data Definition Language**
> Məlumatların strukturunu yaradır, dəyişdirir, silir. Məlumatların özünə toxunmur.

## Əsas DDL Əmrləri: `CREATE` · `ALTER` · `DROP` · `TRUNCATE`

---

## 4.1 DATABASE Əməliyyatları

```sql
-- ✅ Yeni verilənlər bazası yaratmaq
CREATE DATABASE UniversityDB;

-- ✅ Mövcud bazalar arasında keçid etmək (PostgreSQL)
\c UniversityDB

-- ❌ Bazanı tamamilə silmək (bütün məlumatlar geri dönməz şəkildə silinir!)
DROP DATABASE UniversityDB;

-- ✅ Yalnız mövcuddursa silmək (xəta verməsin deyə)
DROP DATABASE IF EXISTS UniversityDB;
```

> 🔴 **DİQQƏT:** `DROP DATABASE` əmri bütün cədvəlləri, məlumatları və strukturu silir. Bu əmri icra etməzdən əvvəl mütləq əmin olun!

---

## 4.2 TABLE Yaratmaq — `CREATE TABLE`

```sql
-- Tam nümunə: Fakültə cədvəli
CREATE TABLE Faculties (
    FacultyID   INT          PRIMARY KEY,   -- Fakültənin unikal ID-si
    FacultyName VARCHAR(100) NOT NULL        -- Fakültənin adı
);

-- Tam nümunə: Tələbə cədvəli (Foreign Key ilə)
CREATE TABLE Students (
    StudentID    INT            PRIMARY KEY,       -- Unikal tələbə ID
    FirstName    VARCHAR(50)    NOT NULL,           -- Ad (boş ola bilməz)
    LastName     VARCHAR(50),                       -- Soyad (isteğe bağlı)
    BirthDate    DATE,                              -- Doğum tarixi
    AverageGrade DECIMAL(5, 2)  CHECK (AverageGrade BETWEEN 0 AND 100),
    Phone        VARCHAR(20)    UNIQUE,             -- Hər tələbənin fərqli nömrəsi
    FacultyID    INT            REFERENCES Faculties(FacultyID) -- FK: fakültə ilə əlaqə
);
```

---

## 4.3 TABLE Dəyişdirmək — `ALTER TABLE`

```sql
-- ✅ Yeni sütun əlavə etmək
ALTER TABLE Students
ADD COLUMN Email VARCHAR(100);

-- ✅ Sütunun adını dəyişmək (PostgreSQL)
ALTER TABLE Students
RENAME COLUMN Phone TO PhoneNumber;

-- ✅ Sütunun data tipini dəyişmək
ALTER TABLE Students
ALTER COLUMN Email TYPE TEXT;

-- ✅ Sütuna NOT NULL məhdudiyyəti əlavə etmək
ALTER TABLE Students
ALTER COLUMN Email SET NOT NULL;

-- ✅ Mövcud sütunu silmək
ALTER TABLE Students
DROP COLUMN Email;

-- ✅ Cədvəlin adını dəyişmək
ALTER TABLE Students
RENAME TO Undergraduates;
```

---

## 4.4 TABLE Silmək — `DROP TABLE` & `TRUNCATE`

```sql
-- ✅ Cədvəli tamamilə silmək (struktur + məlumat)
DROP TABLE Students;

-- ✅ Yalnız mövcuddursa silmək
DROP TABLE IF EXISTS Students;

-- ✅ TRUNCATE: Yalnız məlumatları silmək, strukturu saxlamaq
-- DROP-dan fərqi: Cədvəl özü silinmir, yalnız içi boşaldılır
TRUNCATE TABLE Students;
```

> 📌 **Fərq:**
> - `DROP TABLE` → Cədvəli struktur ilə birlikdə tamamilə silir
> - `TRUNCATE TABLE` → Yalnız içindəki bütün sətirləri silir, cədvəl qalır
> - `DELETE FROM` → Şərtə görə seçici silmə (DML əmridir, bax Bölmə 5)

---

# 5. DML — Məlumat İdarəetməsi

> **DML = Data Manipulation Language**
> Məlumatları əlavə edir, oxuyur, dəyişdirir, silir. Strukturu dəyişdirmir.
> **CRUD = Create · Read · Update · Delete**

---

## 5.1 INSERT — Məlumat Əlavə Etmək

```sql
-- ✅ Bir sətir əlavə etmək (bütün sütunlar)
INSERT INTO Students (StudentID, FirstName, LastName, AverageGrade, FacultyID)
VALUES (101, 'Murad', 'Aliyev', 95.50, 1);

-- ✅ Bir neçə sətir birdə əlavə etmək
INSERT INTO Students (StudentID, FirstName, LastName, AverageGrade, FacultyID)
VALUES
    (102, 'Leyla', 'Həsənova', 88.00, 2),
    (103, 'Tural', 'Məmmədov', 72.50, 1),
    (104, 'Aytən', 'Quliyeva', 91.25, 3);

-- ✅ Bəzi sütunları buraxmaq (NULL dəyər alır)
-- BirthDate və Phone daxil edilmir → NULL olacaq
INSERT INTO Students (StudentID, FirstName, AverageGrade)
VALUES (105, 'Nicat', 85.00);
```

> ⚠️ Sütun adlarını yazmaq məcburi deyil, amma **tövsiyə olunur** — gələcəkdə cədvəl dəyişsə sorğunuz yenə işləyər.

---

## 5.2 UPDATE — Məlumat Dəyişdirmək

```sql
-- ✅ Tək bir tələbənin balını dəyişmək
UPDATE Students
SET AverageGrade = 97.00
WHERE StudentID = 101;  -- ← WHERE olmadan BÜTÜN tələbələrin balı dəyişər!

-- ✅ Birdən çox sütunu eyni anda dəyişmək
UPDATE Students
SET FirstName    = 'Murad Əli',
    AverageGrade = 99.00,
    FacultyID    = 2
WHERE StudentID = 101;

-- ✅ Şərtə görə toplu yeniləmə
-- Balı 50-dən aşağı olan bütün tələbələrin fakültəsini sıfırla
UPDATE Students
SET FacultyID = NULL
WHERE AverageGrade < 50;
```

> 🔴 **XƏBƏRDARLIK:** `WHERE` şərti olmayan `UPDATE` bütün cədvəli dəyişdirir! Həmişə əvvəlcə `SELECT` ilə yoxlayın.

---

## 5.3 DELETE — Məlumat Silmək

```sql
-- ✅ Spesifik bir sətiri silmək
DELETE FROM Students
WHERE StudentID = 101;

-- ✅ Şərtə görə toplu silmə
DELETE FROM Students
WHERE AverageGrade < 40;  -- Balı 40-dan aşağı olanları sil

-- ✅ Cədvəldəki bütün sətirləri silmək (TRUNCATE alternativi)
DELETE FROM Students;  -- WHERE olmadan hamısını silir

-- ✅ Bir neçə şərtlə silmə
DELETE FROM Students
WHERE FacultyID = 3
AND AverageGrade < 60;  -- Fakültə 3-dən, balı 60-dan aşağı olanları sil
```

---

# 6. DCL — İcazə İdarəetməsi

> **DCL = Data Control Language**
> Verilənlər bazasında istifadəçi hüquqlarını idarə edir. Təhlükəsizlik üçün vacibdir.

## `GRANT` və `REVOKE`

```sql
-- ✅ İstifadəçiyə oxuma icazəsi vermək
GRANT SELECT ON Students TO analyst_user;

-- ✅ Birdən çox icazə vermək
GRANT SELECT, INSERT, UPDATE ON Students TO developer_user;

-- ✅ Bütün icazələri vermək (DBA üçün)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_user;

-- ✅ İcazəni geri götürmək
REVOKE INSERT ON Students FROM developer_user;

-- ✅ Bütün icazələri geri götürmək
REVOKE ALL PRIVILEGES ON Students FROM developer_user;
```

> 📌 **Prinsip:** Hər istifadəçiyə yalnız işini görə biləcəyi minimum icazəni verin. Bu **"Least Privilege"** prinsipidir.

---

# 7. TCL — Transaksiya İdarəetməsi

> **TCL = Transaction Control Language**
> Bir neçə DML əməliyyatını bir vahid kimi idarə edir. Ya hamısı uğurlu olur, ya da heç biri.

## 💡 Transaksiya nədir?

> 📌 **Analogiya:** Bank köçürməsini düşünün: Hesabdan pul çıxmaq VƏ digər hesaba pul gəlmək ya ikisi də baş verir, ya da heçbiri. Bu bir transaksiyadır.

```sql
-- ✅ Sadə transaksiya nümunəsi
BEGIN;  -- Transaksiyanı başlat

    UPDATE Accounts SET Balance = Balance - 500 WHERE AccountID = 1;  -- Pulun çıxması
    UPDATE Accounts SET Balance = Balance + 500 WHERE AccountID = 2;  -- Pulun gəlməsi

COMMIT;  -- Hər şey yaxşıdırsa, dəyişiklikləri saxla

-- ❌ Xəta baş verərsə, hər şeyi geri al
ROLLBACK;  -- Transaksiyanın əvvəlki vəziyyətinə qayıt

-- ✅ SAVEPOINT — transaksiyanın müəyyən nöqtəsinə geri qayıtmaq
BEGIN;
    INSERT INTO Students VALUES (200, 'Test', 'User', 80.0, 1);
    SAVEPOINT my_savepoint;                    -- Bu nöqtəni yadda saxla

    DELETE FROM Students WHERE StudentID = 101; -- Bu əməliyyat yanlışdır
    ROLLBACK TO SAVEPOINT my_savepoint;         -- Yalnız son DELETE-i geri al, INSERT qalır

COMMIT;  -- İlk INSERT-i saxla
```

| Əmr | Məqsəd |
|---|---|
| `BEGIN` / `START TRANSACTION` | Transaksiyanı başlatmaq |
| `COMMIT` | Dəyişiklikləri qəti olaraq saxlamaq |
| `ROLLBACK` | Bütün dəyişiklikləri geri almaq |
| `SAVEPOINT name` | Ara nöqtə yaratmaq |
| `ROLLBACK TO SAVEPOINT name` | Müəyyən nöqtəyə qayıtmaq |

---

# 8. SELECT — Məlumat Oxumaq

## 8.1 Əsas SELECT Sintaksisi

```sql
-- ✅ Bütün sütunları gətirmək
SELECT * FROM Students;

-- ✅ Spesifik sütunları gətirmək
SELECT FirstName, LastName, AverageGrade FROM Students;

-- ✅ Alias (ləqəb) istifadə etmək — nəticədə sütun adını dəyişir
SELECT
    FirstName    AS "Ad",
    LastName     AS "Soyad",
    AverageGrade AS "Orta Bal"
FROM Students;

-- ✅ DISTINCT — təkrarlanan dəyərləri bir dəfə göstər
SELECT DISTINCT FacultyID FROM Students;
```

---

## 8.2 WHERE — Filtrasiya

```sql
-- ✅ Bərabərlik şərti
SELECT * FROM Students WHERE FacultyID = 1;

-- ✅ Müqayisə operatorları
SELECT * FROM Students WHERE AverageGrade >= 90;  -- 90 və yuxarı
SELECT * FROM Students WHERE AverageGrade != 0;   -- 0-dan fərqli

-- ✅ AND / OR / NOT — məntiqi operatorlar
SELECT * FROM Students
WHERE AverageGrade >= 80
AND FacultyID = 1;  -- Hər iki şərt doğru olmalıdır

SELECT * FROM Students
WHERE FacultyID = 1
OR FacultyID = 3;   -- Hər hansı biri doğru olsa kifayətdir

-- ✅ BETWEEN — aralıq filtri (həddlər daxildir)
SELECT * FROM Students
WHERE AverageGrade BETWEEN 70 AND 90;  -- 70 və 90 daxil olmaqla

-- ✅ IN — siyahıdan biri
SELECT * FROM Students
WHERE FacultyID IN (1, 2, 5);  -- Fakültəsi 1, 2, ya 5 olanlar

-- ✅ LIKE — pattern matching (şablon axtarışı)
-- % → istənilən sayda simvol
-- _ → tam olaraq bir simvol
SELECT * FROM Students WHERE FirstName LIKE 'A%';    -- Adı A ilə başlayanlar
SELECT * FROM Students WHERE LastName  LIKE '%ov';   -- Soyadı "ov" ilə bitənlər
SELECT * FROM Students WHERE FirstName LIKE '_____'; -- Tam 5 simvol uzunluğunda ad

-- ✅ IS NULL / IS NOT NULL — boş dəyərlər
SELECT * FROM Students WHERE FacultyID IS NULL;     -- Fakültəsi təyin edilməyənlər
SELECT * FROM Students WHERE Phone     IS NOT NULL; -- Telefonu olanlar
```

---

## 8.3 ORDER BY — Sıralama

```sql
-- ✅ Artan sıra (ASC default-dur, yazmaq məcburi deyil)
SELECT FirstName, AverageGrade FROM Students
ORDER BY AverageGrade ASC;

-- ✅ Azalan sıra
SELECT FirstName, AverageGrade FROM Students
ORDER BY AverageGrade DESC;

-- ✅ Birdən çox sütuna görə sıralama
-- Əvvəl fakültəyə görə, eyni fakültədə isə balına görə sırala
SELECT FirstName, FacultyID, AverageGrade FROM Students
ORDER BY FacultyID ASC, AverageGrade DESC;
```

---

## 8.4 LIMIT / OFFSET — Nəticə Sayını Məhdudlaşdırmaq

```sql
-- ✅ Yalnız ilk 5 nəticəni gətir
SELECT * FROM Students
ORDER BY AverageGrade DESC
LIMIT 5;

-- ✅ OFFSET — ilk N nəticəni keç (səhifələmə üçün)
-- 11-20-ci tələbələri gətir (2-ci səhifə)
SELECT * FROM Students
ORDER BY StudentID
LIMIT 10 OFFSET 10;
```

---

# 9. Aqreqat Funksiyalar & GROUP BY & HAVING

## 9.1 Aqreqat Funksiyalar

> Aqreqat funksiyalar bir **sətir qrupu üzərində** hesablama aparır və **tək bir nəticə** qaytarır.

| Funksiya | Məqsəd | Nümunə |
|---|---|---|
| `COUNT()` | Sətir sayını hesablamaq | `COUNT(*)` |
| `SUM()` | Dəyərləri cəmləmək | `SUM(Salary)` |
| `AVG()` | Orta qiyməti tapmaq | `AVG(AverageGrade)` |
| `MIN()` | Ən kiçik dəyəri tapmaq | `MIN(HireDate)` |
| `MAX()` | Ən böyük dəyəri tapmaq | `MAX(Salary)` |

```sql
-- ✅ Cədvəldəki ümumi tələbə sayı
SELECT COUNT(*) AS "Ümumi Tələbə Sayı"
FROM Students;

-- ✅ Orta bal
SELECT AVG(AverageGrade) AS "Orta Bal"
FROM Students;

-- ✅ Ən yüksək və ən aşağı bal
SELECT
    MAX(AverageGrade) AS "Ən Yüksək Bal",
    MIN(AverageGrade) AS "Ən Aşağı Bal"
FROM Students;

-- ✅ COUNT(*) vs COUNT(sütun): NULL dəyərləri
-- COUNT(*) bütün sətirləri sayır (NULL-lar da daxil)
-- COUNT(Phone) yalnız NULL olmayan sətirləri sayır
SELECT
    COUNT(*)     AS "Ümumi Say",
    COUNT(Phone) AS "Telefonu Olan Tələbələr"
FROM Students;
```

---

## 9.2 GROUP BY — Qruplaşdırma

> `GROUP BY` cədvəli müəyyən sütunun dəyərlərinə görə **qruplara** ayırır və aqreqat funksiyalarını hər qrupa tətbiq edir.

```sql
-- ✅ Hər fakültədəki tələbə sayı
SELECT
    FacultyID,
    COUNT(StudentID) AS "Tələbə Sayı"
FROM Students
GROUP BY FacultyID;

-- ✅ Hər fakültənin orta balı
SELECT
    FacultyID,
    COUNT(StudentID)     AS "Tələbə Sayı",
    AVG(AverageGrade)    AS "Orta Bal",
    MAX(AverageGrade)    AS "Ən Yüksək Bal"
FROM Students
GROUP BY FacultyID
ORDER BY AVG(AverageGrade) DESC; -- Ən yüksək ortalı fakültə birinci

-- ⚠️ QAYDA: SELECT-də aqreqat funksiyasında olmayan hər sütun
--            GROUP BY-da mütləq olmalıdır!
```

---

## 9.3 HAVING — Qrupların Filtrasiyası

> `HAVING`, `WHERE`-ə bənzəyir, lakin **qrupları** filtrləyir — aqreqat funksiya nəticəsinə görə.

```sql
-- ✅ WHERE vs HAVING fərqi
SELECT FacultyID, AVG(AverageGrade) AS AvgGrade
FROM Students
WHERE AverageGrade > 50       -- 1. Əvvəlcə fərdi sətirləri filtrlə (aqreqasiyadan ƏVVƏl)
GROUP BY FacultyID
HAVING AVG(AverageGrade) > 80; -- 2. Sonra qrupları filtrlə (aqreqasiyadan SONRA)

-- ✅ 10-dan çox tələbəsi olan fakültələr
SELECT
    FacultyID,
    COUNT(StudentID) AS "Tələbə Sayı"
FROM Students
GROUP BY FacultyID
HAVING COUNT(StudentID) > 10;

-- ✅ Orta balı 75-80 arasında olan fakültələr
SELECT FacultyID, AVG(AverageGrade) AS AvgGrade
FROM Students
GROUP BY FacultyID
HAVING AVG(AverageGrade) BETWEEN 75 AND 85;
```

### 🔄 SQL-in İcra Sırası (Məntiqi)

```
1. FROM       → Hansı cədvəldən?
2. JOIN       → Cədvəlləri birləşdir
3. WHERE      → Fərdi sətirləri filtrə
4. GROUP BY   → Qruplaşdır
5. HAVING     → Qrupları filtrə
6. SELECT     → Göstəriləcək sütunları seç
7. ORDER BY   → Sırala
8. LIMIT      → Sayı məhdudlaşdır
```

---

# 10. SQL JOINs — Cədvəllərin Birləşdirilməsi

## 💡 Nəzəriyyə

Real layihələrdə məlumatlar tək bir cədvəldə saxlanmır. Məsələn, tələbənin fakültəsi haqqında məlumat ayrı bir cədvəldədir. **JOIN** bu cədvəlləri birləşdirməyə imkan verir.

> 📌 JOIN-lər **Primary Key (PK)** — **Foreign Key (FK)** əlaqəsi üzərində qurulur.

### Nümunə Cədvəllərimiz

```sql
-- Fakültə cədvəli
CREATE TABLE Faculties (
    FacultyID   INT PRIMARY KEY,
    FacultyName VARCHAR(100) NOT NULL
);

-- Tələbə cədvəli (FacultyID → Faculties.FacultyID FK-dır)
CREATE TABLE Students (
    StudentID    INT PRIMARY KEY,
    FirstName    VARCHAR(50),
    AverageGrade DECIMAL(5,2),
    FacultyID    INT REFERENCES Faculties(FacultyID)
);

-- Məlumat əlavə edək
INSERT INTO Faculties VALUES (1, 'Mühəndislik'), (2, 'Tibb'), (3, 'Hüquq');

INSERT INTO Students VALUES
    (101, 'Murad',  95.0, 1),   -- Mühəndislik fakültəsindədir
    (102, 'Leyla',  88.0, 2),   -- Tibb fakültəsindədir
    (103, 'Tural',  72.0, NULL),-- Fakültəsi YOX (NULL)
    (104, 'Aytən',  91.0, 1);   -- Mühəndislik fakültəsindədir
-- Fakültə 3 (Hüquq) — heç bir tələbəsi yoxdur
```

---

## 10.1 INNER JOIN — Kəsişmə

> Yalnız **hər iki cədvəldə uyğun gələn** sətirləri qaytarır. Uyğunluq olmayan sətirlər nəticədən kənarlaşdırılır.

```
Students:          Faculties:         INNER JOIN Nəticəsi:
Murad  → FK=1  ←→  1=Mühəndislik  →  Murad,  Mühəndislik  ✅
Leyla  → FK=2  ←→  2=Tibb         →  Leyla,  Tibb          ✅
Tural  → FK=NULL  (uyğunluq yox)  →  ❌ Nəticəyə düşmür
Aytən  → FK=1  ←→  1=Mühəndislik  →  Aytən,  Mühəndislik  ✅
                   3=Hüquq (uyğun tələbə yox) → ❌ Nəticəyə düşmür
```

```sql
-- ✅ INNER JOIN nümunəsi
SELECT
    S.FirstName    AS "Tələbə Adı",
    S.AverageGrade AS "Orta Bal",
    F.FacultyName  AS "Fakültə"
FROM Students S                                  -- S alias (qısaltma)
INNER JOIN Faculties F ON S.FacultyID = F.FacultyID; -- Birləşmə şərti

-- Nəticə:
-- Murad  | 95.0 | Mühəndislik
-- Leyla  | 88.0 | Tibb
-- Aytən  | 91.0 | Mühəndislik
-- (Tural NULL FK-a görə nəticəyə düşmür)
-- (Hüquq fakültəsi tələbəsi olmadığına görə nəticəyə düşmür)
```

**Ne vaxt istifadə etməli:** Hər iki cədvəldə məlumatın olması vacib olduqda. Məs: "Yalnız fakültəsi olan tələbələri göstər."

---

## 10.2 LEFT JOIN — Sol Üstünlük

> **Sol cədvəldəki bütün sətirləri** qaytarır. Sağ cədvəldə uyğunluq yoxdursa, `NULL` qoyulur.

```
LEFT JOIN Nəticəsi (Sol = Students):
Murad  | 95.0 | Mühəndislik   ← uyğunluq var
Leyla  | 88.0 | Tibb           ← uyğunluq var
Tural  | 72.0 | NULL           ← sol cədvəldədir, sağda uyğunluq yox → NULL
Aytən  | 91.0 | Mühəndislik   ← uyğunluq var
(Hüquq fakültəsi burda görünmür — çünki sağ cədvəldir)
```

```sql
-- ✅ LEFT JOIN nümunəsi
SELECT
    S.FirstName    AS "Tələbə Adı",
    S.AverageGrade AS "Orta Bal",
    F.FacultyName  AS "Fakültə"
FROM Students S
LEFT JOIN Faculties F ON S.FacultyID = F.FacultyID;

-- ✅ LEFT JOIN-in əsas tətbiqi: Uyğunsuz məlumatları tapmaq
-- "Fakültəyə aid edilməmiş tələbələri tap"
SELECT S.FirstName
FROM Students S
LEFT JOIN Faculties F ON S.FacultyID = F.FacultyID
WHERE F.FacultyID IS NULL;  -- Sağ cədvəldə uyğunluq olmayanlar
-- Nəticə: Tural
```

**Ne vaxt istifadə etməli:** Sol cədvəldəki bütün məlumatları görmək istədikdə, hətta uyğunluğu olmasa belə. Məs: "Fakültəsi olsun ya olmasın, bütün tələbələri göstər."

---

## 10.3 RIGHT JOIN — Sağ Üstünlük

> **Sağ cədvəldəki bütün sətirləri** qaytarır. Sol cədvəldə uyğunluq yoxdursa, `NULL` qoyulur.

```sql
-- ✅ RIGHT JOIN nümunəsi
SELECT
    S.FirstName   AS "Tələbə Adı",
    F.FacultyName AS "Fakültə"
FROM Students S
RIGHT JOIN Faculties F ON S.FacultyID = F.FacultyID;

-- Nəticə:
-- Murad  | Mühəndislik  ← uyğunluq var
-- Aytən  | Mühəndislik  ← uyğunluq var
-- Leyla  | Tibb          ← uyğunluq var
-- NULL   | Hüquq         ← sağ cədvəldədir, tələbəsi yox → NULL
-- (Tural görünmür — fakültəsi olmadığından)
```

> 📌 **Praktik Məsləhət:** `RIGHT JOIN`-i əksər hallarda `LEFT JOIN`-ə çevirə bilərsiniz: sadəcə cədvəllərin yerini dəyişin. Çox nadir hallarda `RIGHT JOIN` istifadə olunur.

---

## 10.4 FULL JOIN — Tam Birləşmə

> **Hər iki cədvəldəki bütün sətirləri** qaytarır. Uyğunluq olmayan tərəflərdə `NULL` yazılır.

```sql
-- ✅ FULL JOIN nümunəsi
SELECT
    S.FirstName   AS "Tələbə Adı",
    F.FacultyName AS "Fakültə"
FROM Students S
FULL OUTER JOIN Faculties F ON S.FacultyID = F.FacultyID;

-- Nəticə:
-- Murad  | Mühəndislik  ← hər ikisindədir
-- Leyla  | Tibb          ← hər ikisindədir
-- Tural  | NULL          ← yalnız Students-dadır
-- Aytən  | Mühəndislik  ← hər ikisindədir
-- NULL   | Hüquq         ← yalnız Faculties-dədir
```

**Ne vaxt istifadə etməli:** Həm fakültəsi olmayan tələbələri, həm də tələbəsi olmayan fakültələri eyni anda görmək istədikdə.

---

## 10.5 SELF JOIN — Cədvəlin Özü ilə Birləşməsi

> Bir cədvəli **özü ilə** birləşdirir. Cədvəldə özünə istinad edən əlaqə olduqda istifadə edilir.

```sql
-- Nümunə: Employees cədvəlində ManagerID, eyni cədvəldəki EmployeeID-yə istinad edir
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName  VARCHAR(50),
    ManagerID  INT REFERENCES Employees(EmployeeID)  -- Özünə istinad!
);

-- ✅ Hər işçi və onun rəhbərinin adını gətir
SELECT
    E.FirstName  AS "İşçi",
    M.FirstName  AS "Rəhbər"
FROM Employees E                                         -- E = işçi kimi
LEFT JOIN Employees M ON E.ManagerID = M.EmployeeID;    -- M = rəhbər kimi
-- LEFT JOIN istifadə edilir ki, rəhbəri olmayanlar (CEO) da nəticəyə düşsün
```

---

## 10.6 Çoxlu JOIN — Multiple Tables

```sql
-- 3 cədvəli birləşdirmək: Tələbə + Fakültə + Bina
CREATE TABLE Buildings (
    BuildingID   INT PRIMARY KEY,
    BuildingName VARCHAR(100)
);

ALTER TABLE Faculties ADD COLUMN BuildingID INT REFERENCES Buildings(BuildingID);

-- ✅ Tələbənin adı, fakültəsi və binanın adı
SELECT
    S.FirstName    AS "Tələbə",
    F.FacultyName  AS "Fakültə",
    B.BuildingName AS "Bina"
FROM Students S
INNER JOIN Faculties F  ON S.FacultyID  = F.FacultyID  -- Students → Faculties
INNER JOIN Buildings B  ON F.BuildingID = B.BuildingID; -- Faculties → Buildings
```

---

## 📊 JOIN Növlərinin Müqayisəsi

| JOIN Növü | Sol Cədvəl | Sağ Cədvəl | İstifadə Ssenarisı |
|---|---|---|---|
| `INNER JOIN` | Yalnız uyğun | Yalnız uyğun | Hər iki tərəfdə uyğunluq vacibdir |
| `LEFT JOIN` | Hamısı | Yalnız uyğun (yoxdursa NULL) | Sol cədvəlin hamısını görmək |
| `RIGHT JOIN` | Yalnız uyğun (yoxdursa NULL) | Hamısı | Sağ cədvəlin hamısını görmək |
| `FULL JOIN` | Hamısı | Hamısı | Hər iki tərəfin hamısını görmək |
| `SELF JOIN` | — | — | Cədvəldaxili hierarchiya |

---

# 11. Master Tips & Best Practices

## ✅ Əsas Qaydalar

### 1. Alias (Ləqəb) İstifadə Edin
```sql
-- ❌ Uzun və oxunması çətin
SELECT Students.FirstName FROM Students INNER JOIN Faculties ON Students.FacultyID = Faculties.FacultyID;

-- ✅ Alias ilə qısa və oxunaqlı
SELECT S.FirstName FROM Students S INNER JOIN Faculties F ON S.FacultyID = F.FacultyID;
```

### 2. UPDATE/DELETE-dən Əvvəl SELECT Edin
```sql
-- Silmədən əvvəl nəyin silinəcəyini yoxla
SELECT * FROM Students WHERE AverageGrade < 40;
-- Nəticəyə baxdıqdan sonra DELETE et
DELETE FROM Students WHERE AverageGrade < 40;
```

### 3. NULL Dəyərlərinə Diqqət Edin
```sql
-- ❌ Yanlış: NULL = NULL həmişə FALSE qaytarır!
SELECT * FROM Students WHERE FacultyID = NULL;

-- ✅ Doğru: IS NULL istifadə et
SELECT * FROM Students WHERE FacultyID IS NULL;
```

### 4. WHERE vs HAVING Seçimi
```sql
-- WHERE: Aqreqasiyadan ƏVVƏL fərdi sətirləri filtrləyir
-- HAVING: Aqreqasiyadan SONRA qrupları filtrləyir

-- ✅ Düzgün istifadə
SELECT FacultyID, AVG(AverageGrade)
FROM Students
WHERE AverageGrade > 0           -- Fərdi sətir filtri (WHERE)
GROUP BY FacultyID
HAVING AVG(AverageGrade) > 80;   -- Qrup filtri (HAVING)
```

### 5. INDEX — Performans Artırımı
```sql
-- Tez-tez axtarış etdiyiniz sütunlara index yaradın
CREATE INDEX idx_students_faculty ON Students(FacultyID);
CREATE INDEX idx_students_grade   ON Students(AverageGrade);

-- Bu sayədə milyonlarla sətir arasında axtarış çox sürətli olur
```

---

## 🔄 SQL Əmrləri Xülasəsi

```
DDL (Struktur):
  CREATE DATABASE / TABLE  →  Yarat
  ALTER TABLE              →  Dəyişdir
  DROP DATABASE / TABLE    →  Tamamilə sil
  TRUNCATE TABLE           →  Məlumatları sil, strukturu saxla

DML (Məlumat):
  INSERT INTO              →  Əlavə et
  SELECT ... FROM          →  Oxu
  UPDATE ... SET           →  Dəyişdir
  DELETE FROM              →  Sil

DCL (İcazə):
  GRANT                    →  İcazə ver
  REVOKE                   →  İcazəni geri al

TCL (Transaksiya):
  BEGIN                    →  Transaksiyanı başlat
  COMMIT                   →  Saxla
  ROLLBACK                 →  Geri al
  SAVEPOINT                →  Nöqtə qoy
```

---
