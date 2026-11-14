// Demo catalogue so a fresh install is not empty. Generic products, invented in-store barcodes.
// Replace with real data via Items > Import CSV.
export const DEMO = [
  // name, name_ar, category, price USD, unit
  ['Labneh 500 g', 'لبنة 500 غ', 'dairy', 2.5, 'pc'], ['White cheese', 'جبنة بيضاء', 'dairy', 7, 'kg'],
  ['Full-fat milk 1 L', 'حليب كامل الدسم 1 ل', 'dairy', 1.6, 'pc'], ['Plain yogurt 1 kg', 'لبن زبادي 1 كلغ', 'dairy', 2.2, 'pc'],
  ['Eggs, tray of 30', 'بيض صينية 30', 'dairy', 4.8, 'pc'],
  ['Arabic bread', 'خبز عربي', 'bakery', 1, 'pc'], ["Za'atar manakish", 'منقوشة زعتر', 'bakery', 1.5, 'pc'], ['Croissant', 'كرواسان', 'bakery', 0.8, 'pc'],
  ['Tomatoes', 'بندورة', 'produce', 1.2, 'kg'], ['Cucumbers', 'خيار', 'produce', 1, 'kg'], ['Potatoes', 'بطاطا', 'produce', 0.9, 'kg'],
  ['Lemons', 'ليمون', 'produce', 1.4, 'kg'], ['Bananas', 'موز', 'produce', 1.8, 'kg'], ['Apples', 'تفاح', 'produce', 2, 'kg'],
  ['Chicken breast', 'صدر دجاج', 'meat', 6.5, 'kg'], ['Minced beef', 'لحمة مفرومة', 'meat', 11, 'kg'], ['Chicken drumsticks', 'أفخاذ دجاج', 'meat', 4.2, 'kg'],
  ['Frozen peas 450 g', 'بازيلا مجمدة 450 غ', 'frozen', 1.9, 'pc'], ['Frozen fries 1 kg', 'بطاطا مقلية مجمدة 1 كلغ', 'frozen', 3.2, 'pc'], ['Ice cream tub 1 L', 'بوظة 1 ل', 'frozen', 4.5, 'pc'],
  ['Rice 5 kg', 'رز 5 كلغ', 'pantry', 6.5, 'pc'], ['Sugar 1 kg', 'سكر 1 كلغ', 'pantry', 1.3, 'pc'], ['Olive oil 1 L', 'زيت زيتون 1 ل', 'pantry', 9.5, 'pc'],
  ['Sunflower oil 1.5 L', 'زيت دوار الشمس 1.5 ل', 'pantry', 3.8, 'pc'], ['Lentils 900 g', 'عدس 900 غ', 'pantry', 1.8, 'pc'], ['Chickpeas can 400 g', 'حمص معلب 400 غ', 'pantry', 0.9, 'pc'],
  ['Tomato paste 800 g', 'معجون بندورة 800 غ', 'pantry', 2.2, 'pc'], ['Pasta 500 g', 'معكرونة 500 غ', 'pantry', 1.1, 'pc'], ['Ground coffee 250 g', 'قهوة مطحونة 250 غ', 'pantry', 3.5, 'pc'], ['Tuna can', 'تونا معلبة', 'pantry', 1.6, 'pc'],
  ['Potato chips', 'شيبس بطاطا', 'snacks', 0.7, 'pc'], ['Chocolate bar', 'لوح شوكولا', 'snacks', 0.6, 'pc'], ['Biscuits pack', 'بسكويت', 'snacks', 0.9, 'pc'], ['Roasted nuts 250 g', 'مكسرات محمصة 250 غ', 'snacks', 3, 'pc'],
  ['Water 1.5 L', 'مياه 1.5 ل', 'drinks', 0.5, 'pc'], ['Orange juice 1 L', 'عصير برتقال 1 ل', 'drinks', 1.8, 'pc'], ['Soda can', 'مشروب غازي علبة', 'drinks', 0.6, 'pc'],
  ['Energy drink', 'مشروب طاقة', 'drinks', 1.5, 'pc'], ['Sparkling water', 'مياه غازية', 'drinks', 0.6, 'pc'],
  ['Dish soap 750 ml', 'سائل جلي 750 مل', 'cleaning', 2, 'pc'], ['Laundry detergent 3 kg', 'مسحوق غسيل 3 كلغ', 'cleaning', 8.5, 'pc'], ['Bleach 1 L', 'كلور 1 ل', 'cleaning', 1.2, 'pc'],
  ['Toilet paper, 12 rolls', 'محارم حمام 12 رول', 'cleaning', 5, 'pc'], ['Paper towels', 'مناديل مطبخ', 'cleaning', 2.5, 'pc'],
  ['Shampoo 400 ml', 'شامبو 400 مل', 'personal', 3.8, 'pc'], ['Toothpaste 100 ml', 'معجون أسنان 100 مل', 'personal', 2, 'pc'], ['Soap bar', 'صابونة', 'personal', 0.8, 'pc'],
  ['Cigarette pack', 'علبة سجائر', 'tobacco', 2, 'pc'], ['Hookah tobacco 250 g', 'معسل 250 غ', 'tobacco', 6, 'pc'], ['Disposable vape', 'فيب يستعمل مرة واحدة', 'tobacco', 9, 'pc'],
  ['Lighter', 'ولاعة', 'tobacco', 0.7, 'pc'], ['Rolling papers', 'ورق لف', 'tobacco', 0.5, 'pc'],
  ['Water 6-pack, 1.5 L', 'مياه ٦ قوارير 1.5 ل'.replace('٦','6'), 'drinks', 2.6, 'pc'], ['Instant cappuccino sachet', 'كابتشينو سريع', 'pantry', 0.4, 'pc'],
  ['Wafer chocolate', 'ويفر شوكولا', 'snacks', 0.5, 'pc'], ['AA batteries, 4 pack', 'بطاريات AA 4', 'other', 3, 'pc'], ['Tissue box', 'علبة مناديل', 'cleaning', 1.2, 'pc'],
];
const ean13 = (body12) => {
  const s = [...body12].reduce((a, d, i) => a + Number(d) * (i % 2 ? 3 : 1), 0);
  return body12 + ((10 - (s % 10)) % 10);
};
export function seedDemo(db) {
  const ins = db.prepare('INSERT INTO items(barcode,name,name_ar,category,price_cents,cost_cents,stock,min_stock,unit,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?)');
  const at = new Date().toISOString();
  DEMO.forEach(([name, ar, cat, usd, unit], n) => {
    const price = Math.round(usd * 100);
    const kg = unit === 'kg';
    ins.run(ean13(`2000000${String(n + 1).padStart(5, '0')}`), name, ar, cat, price, Math.round(price * 0.72), kg ? 20 + (n % 15) : 12 + ((n * 7) % 48), kg ? 8 : 6, unit, at);
  });
}
