---
name: Anti-Slop Craft
colors:
  surface: '#FFFFFF'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#424751'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#727782'
  outline-variant: '#c2c6d2'
  surface-tint: '#1960a5'
  primary: '#003f74'
  on-primary: '#ffffff'
  primary-container: '#02569b'
  on-primary-container: '#aaccff'
  inverse-primary: '#a4c9ff'
  secondary: '#505f76'
  on-secondary: '#ffffff'
  secondary-container: '#d0e1fb'
  on-secondary-container: '#54647a'
  tertiary: '#682d00'
  on-tertiary: '#ffffff'
  tertiary-container: '#8b3f03'
  on-tertiary-container: '#ffbb95'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d4e3ff'
  primary-fixed-dim: '#a4c9ff'
  on-primary-fixed: '#001c39'
  on-primary-fixed-variant: '#004883'
  secondary-fixed: '#d3e4fe'
  secondary-fixed-dim: '#b7c8e1'
  on-secondary-fixed: '#0b1c30'
  on-secondary-fixed-variant: '#38485d'
  tertiary-fixed: '#ffdbc9'
  tertiary-fixed-dim: '#ffb68d'
  on-tertiary-fixed: '#321200'
  on-tertiary-fixed-variant: '#763300'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
  background-subtle: '#F8FAFC'
  border-subtle: '#E2E8F0'
  text-secondary: '#64748B'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-desktop: 1.5rem
  margin: 1rem
  margin-tablet: 1.5rem
  margin-desktop: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

# UI Design Principles — Anti AI Slop

### 1. Overall Design Direction
UI harus terlihat seperti produk digital yang benar-benar dirancang oleh product designer, bukan hasil template AI atau UI generator.
Prioritaskan: Simple, Clean, Modern, Functional, Professional, Visually balanced, Memiliki karakter visual yang konsisten.

### 2. Avoid AI Slop
Hindari:
- Terlalu banyak gradient besar sebagai background.
- Glassmorphism berlebihan.
- Banyak floating cards tanpa fungsi nyata.
- Excessive rounded corners & heavy drop shadows.
- Decorative blobs atau abstract shapes tanpa fungsi.
- Terlalu banyak icon hanya untuk dekorasi.
- Layout repetitif yang serba card.
- Penggunaan emoji sebagai pengganti icon atau pelengkap teks (misal: "Quiz 🎯", "Settings ⚙️", "Rocket 🚀").

Jika sebuah elemen tidak membantu usability, hierarchy, branding, atau visual clarity, hilangkan.

### 3. Color & Gradient
Gunakan 1-2 gradient utama hanya sebagai aksen. Solid color untuk sebagian besar UI.
- Background: neutral / solid (`#FAF8FF` / `#F8FAFC`)
- Surface: `#FFFFFF`
- Primary: `#02569B` (Flutter Navy Blue / Indigo)
- Primary Dark: `#003F74`
- Border: subtle neutral (`#E2E8F0`)
- Text: dark neutral (`#131B2E` / `#0F172A`)
- Secondary text: muted neutral (`#64748B` / `#424751`)
- Success: `#10B981` (background `#F0FDF4`, border `#BBF7D0`)
- Warning / XP: `#F59E0B` (background `#FFFBEB`, border `#FDE68A`)
- Destructive: `#EF4444` (background `#FEF2F2`, border `#FECACA`)

### 4. Borders Over Shadows
Default preference: `border > shadow`.
Gunakan 1px subtle border dengan low contrast. Shadow minimal hanya untuk modal, dropdown, atau floating action buttons.

### 5. Card Design
Surface + subtle border + clean typography.
Gunakan moderate border radius (10px - 14px), padding proporsional (16px), dan visual hierarchy yang tegas.

### 6. Border Radius
Konsisten dan moderat:
- Card / Containers: 12px - 16px (`rounded.md` / `rounded.lg`)
- Buttons & Inputs: 8px - 10px (`rounded.DEFAULT`)
- Pill shape (`rounded.full`): hanya untuk status badges, chips, tags, dan filter.

### 7. Typography
- Headings & Titles: Plus Jakarta Sans (Weight: 600 - 700)
- Body & Labels: Inter (Weight: 400 - 500)
- Pertahankan kontras tajam WCAG AA ($\ge 4.5:1$).

### 8. Iconography — Professional & No Emojis
Strictly no emojis! Gunakan Material Icons / SVG Vector dengan optical weight dan ukuran yang seragam.
Icon digunakan untuk mempermudah navigasi dan affordance, bukan sekadar ornamen.

### 9. Design Quality Checklist
Sebelum menganggap UI selesai, pastikan:
- [ ] Tidak terlihat seperti generic AI-generated template.
- [ ] 100% bebas dari emoji pada button, label, header, card, dan tab UI.
- [ ] Menggunakan vector system icons (Material Icons) secara seragam.
- [ ] Warna background dan card solid, bukan full-bleed gradient.
- [ ] Border 1px subtle mendominasi dibanding shadow.
- [ ] Typography menggunakan Plus Jakarta Sans (Headings) dan Inter (Body).
- [ ] Rasio kontras teks memenuhi standar WCAG AA.
- [ ] Tampilan rapi, elegan, dan fungsional di mobile maupun desktop.
