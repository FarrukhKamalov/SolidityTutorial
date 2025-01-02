# Lottery Smart Contract

Bu Ethereum asosida yozilgan oddiy lotereya smart-kontrakti. Ishtirokchilar 1 Ether to‘lab lotereyada qatnashishlari mumkin. Lotereyada kamida 3 ishtirokchi bo‘lganda, boshqaruvchi (manager) g‘olibni tanlaydi. Mukofot jamg‘armasidan 15% komissiya olinib, qolgan qismi g‘olibga yuboriladi.

---

## Xususiyatlari
- Har bir ishtirokchi aniq 1 Ether yuborib, lotereyada qatnashadi.
- Boshqaruvchi kontrakt balansini ko‘ra oladi va g‘olibni tanlaydi.
- Jamg‘armaning **15%** qismi komissiya sifatida olinadi, qolgan **85%** qismi g‘olibga yuboriladi.

---

## Kontrakt haqida ma’lumot

### **O‘zgaruvchilar**
- `manager`: Kontrakt boshqaruvchisi (uni yaratgan shaxsning manzili).
- `players`: Lotereyada qatnashayotgan ishtirokchilarning manzillarini saqlaydigan massiv.
- `winner`: Oxirgi g‘olibning manzili.
- `FEE`: Komissiya miqdorini belgilaydigan o‘zgarmas qiymat (15%).

---

## Funksiyalar

### **`constructor`**
- Boshqaruvchining manzilini kontrakt yaratuvchisi (`msg.sender`) deb o‘rnatadi.

### **`participiate`**
- Ishtirokchilarga 1 Ether yuborib lotereyada qatnashish imkonini beradi.
- **Talablar**:
  - Faqat aniq **1 Ether** yuborilishi kerak (`msg.value == 1 ether`).

### **`getBalance`**
- Kontraktning joriy balansini qaytaradi.
- **Talablar**:
  - Bu funksiyani faqat boshqaruvchi chaqirishi mumkin.

### **`random`**
- Lotereya g‘olibini aniqlash uchun pseudo-tasodifiy raqam yaratadi. Buning uchun `block.difficulty`, `block.timestamp` va o‘yinchilar soni (`players.length`) ishlatiladi.
- **Eslatma**: Ushbu usul haqiqiy tasodifiylikni ta'minlamaydi va ishlab chiqarish muhiti uchun xavfsiz emas.

### **`findWinner`**
- Tasodifiy ravishda lotereya g‘olibini tanlaydi.
- Jamg‘armaning **85%** qismini g‘olibga yuboradi.
- **15% komissiya** boshqaruvchi balansida qoladi.
- **Talablar**:
  - Bu funksiyani faqat boshqaruvchi chaqirishi mumkin.
  - Lotereyada kamida **3 ishtirokchi** bo‘lishi kerak.

---

## Foydalanish tartibi

### **Kontraktni deploy qilish**
1. Kontraktni Ethereum muvofiq har qanday vosita (masalan, Remix, Hardhat) yordamida deploy qiling.
2. Kontraktni yaratuvchi boshqaruvchi (`manager`) bo‘ladi.

### **Lotereyada qatnashish**
- Ishtirokchilar `participiate` funksiyasini chaqirib, kontraktga **1 Ether** yuboradilar.
- Ularning manzillari `players` massiviga qo‘shiladi.

### **G‘olibni aniqlash**
- Boshqaruvchi `getBalance` funksiyasini chaqirib, jamg‘arma balansini ko‘radi.
- Keyin `findWinner` funksiyasini chaqirib, tasodifiy g‘olibni aniqlaydi.
- G‘olibga jamg‘armaning **85%** qismini yuboradi, qolgan **15%** boshqaruvchiga qoladi.

---

## Ishlash tartibi

1. Kontraktni deploy qiling (yaratuvchi boshqaruvchi bo‘ladi).
2. 3 yoki undan ortiq ishtirokchi lotereyada qatnashsin (`participiate` funksiyasini chaqirib).
3. Boshqaruvchi `findWinner` funksiyasini chaqiradi va g‘olibni aniqlaydi.
4. G‘olib mukofotni oladi, boshqaruvchi komissiyani saqlab qoladi.

---

## Xavfsizlik bo‘yicha eslatmalar
- `random` funksiyasi haqiqiy tasodifiylikni ta'minlamaydi. Ishlab chiqarish muhitida tasodifiylik uchun oracle (masalan, Chainlink VRF) ishlatilishi kerak.
- Kontraktni faqat ishonchli muhitda deploy qiling va har qanday xatolarga yo‘l qo‘ymaslik uchun audit qildiring.

---
