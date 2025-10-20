// app/main/page.tsx
'use client';

import NavBarUser from '../pages/componants/NavBarUser';

export default function MainPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-[#6fa85e] via-[#8bc273] to-[#a8d48f]">
      {/* 🔹 NavBar เต็มความกว้างด้านบน */}
      <NavBarUser />

      {/* 🔹 Main Area (แบ่งซ้าย-ขวาหลัง Navbar เท่านั้น) */}
      <div className="flex min-h-[calc(100vh-64px)]"> 
        {/* ↑ สมมติ NavBar สูง ~64px ปรับตามจริงได้ */}

        {/* ฝั่งซ้าย */}
        <div className="w-1/2 flex items-center justify-center border-r-8 border-black bg-[#e5f4de]">
          <div className="text-center p-10">
            <h1
              className="text-3xl font-bold text-gray-800 mb-4"
              style={{
                fontFamily: 'monospace',
                textShadow: '2px 2px 0px rgba(0,0,0,0.2)',
              }}
            >
              ◀ LEFT SIDE
            </h1>
            <p
              className="text-gray-700"
              style={{ fontFamily: 'monospace' }}
            >
              (พื้นที่ฝั่งซ้าย — เช่น เมนู, ข้อมูลผู้ใช้)
            </p>
          </div>
        </div>

        {/* ฝั่งขวา */}
        <div className="w-1/2 flex items-center justify-center bg-[#f4ffe5]">
          <div className="text-center p-10">
            <h1
              className="text-3xl font-bold text-gray-800 mb-4"
              style={{
                fontFamily: 'monospace',
                textShadow: '2px 2px 0px rgba(0,0,0,0.2)',
              }}
            >
              RIGHT SIDE ▶
            </h1>
            <p
              className="text-gray-700"
              style={{ fontFamily: 'monospace' }}
            >
              (พื้นที่ฝั่งขวา — เช่น เนื้อหา, ตาราง, หรือกราฟ)
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
