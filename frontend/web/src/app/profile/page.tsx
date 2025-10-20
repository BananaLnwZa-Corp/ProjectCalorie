'use client';

import { useState } from 'react';

export default function ProfilePage() {
  // User data
  const [username] = useState('MyPeach');
  const [weight, setWeight] = useState('65');
  const [height, setHeight] = useState('170');
  const [age, setAge] = useState('25');
  const [gender, setGender] = useState('Male');
  const [goal, setGoal] = useState('Lose Weight');
  
  // State
  const [isEditing, setIsEditing] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [showSuccessModal, setShowSuccessModal] = useState(false);
  const [showErrorModal, setShowErrorModal] = useState(false);
  const [showLogoutModal, setShowLogoutModal] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  
  // Original values for cancel
  const [originalValues, setOriginalValues] = useState({
    weight: '65',
    height: '170',
    age: '25',
    gender: 'Male',
    goal: 'Lose Weight',
  });

  const handleEdit = () => {
    setOriginalValues({ weight, height, age, gender, goal });
    setIsEditing(true);
  };

  const handleCancel = () => {
    setWeight(originalValues.weight);
    setHeight(originalValues.height);
    setAge(originalValues.age);
    setGender(originalValues.gender);
    setGoal(originalValues.goal);
    setIsEditing(false);
  };

  const handleSave = async () => {
    // Validation
    const weightNum = parseFloat(weight);
    const heightNum = parseFloat(height);
    const ageNum = parseInt(age);

    if (isNaN(weightNum) || weightNum < 30 || weightNum > 300) {
      setErrorMessage('⚠ กรุณากรอกน้ำหนักที่ถูกต้อง (30-300 kg)');
      setShowErrorModal(true);
      return;
    }

    if (isNaN(heightNum) || heightNum < 100 || heightNum > 250) {
      setErrorMessage('⚠ กรุณากรอกส่วนสูงที่ถูกต้อง (100-250 cm)');
      setShowErrorModal(true);
      return;
    }

    if (isNaN(ageNum) || ageNum < 10 || ageNum > 120) {
      setErrorMessage('⚠ กรุณากรอกอายุที่ถูกต้อง (10-120 years)');
      setShowErrorModal(true);
      return;
    }

    setIsLoading(true);

    try {
      // TODO: Call API
      await new Promise(resolve => setTimeout(resolve, 1000));

      setIsLoading(false);
      setIsEditing(false);
      setOriginalValues({ weight, height, age, gender, goal });
      setShowSuccessModal(true);
    } catch (error) {
      setIsLoading(false);
      setErrorMessage('✗ เกิดข้อผิดพลาด');
      setShowErrorModal(true);
    }
  };

  const handleLogout = () => {
    console.log('Logged out');
  };

  const handleBack = () => {
    console.log('Back');
  };

  return (
    <div className="min-h-screen relative overflow-hidden">
      {/* Animated Background Gradient */}
      <div 
        className="absolute inset-0"
        style={{
          background: 'linear-gradient(135deg, #5a9448 0%, #6fa85e 25%, #8bc273 50%, #a8d88e 75%, #c5e8b7 100%)',
        }}
      />

      {/* Pixel Grid Pattern */}
      <div 
        className="absolute inset-0 opacity-20"
        style={{
          backgroundImage: `
            linear-gradient(0deg, transparent 24%, rgba(255, 255, 255, .6) 25%, rgba(255, 255, 255, .6) 26%, transparent 27%, transparent 74%, rgba(255, 255, 255, .6) 75%, rgba(255, 255, 255, .6) 76%, transparent 77%, transparent),
            linear-gradient(90deg, transparent 24%, rgba(255, 255, 255, .6) 25%, rgba(255, 255, 255, .6) 26%, transparent 27%, transparent 74%, rgba(255, 255, 255, .6) 75%, rgba(255, 255, 255, .6) 76%, transparent 77%, transparent)
          `,
          backgroundSize: '50px 50px',
        }}
      />

      {/* Diagonal Lines Pattern */}
      <div 
        className="absolute inset-0 opacity-10"
        style={{
          backgroundImage: 'repeating-linear-gradient(45deg, transparent, transparent 10px, rgba(255,255,255,.3) 10px, rgba(255,255,255,.3) 20px)',
        }}
      />

      {/* Floating Pixel Decorations */}
      <div className="absolute top-10 left-10 w-10 h-10 bg-yellow-300 border-4 border-black animate-bounce shadow-lg" style={{ animationDuration: '3s' }}></div>
      <div className="absolute top-24 right-20 w-8 h-8 bg-yellow-400 border-4 border-black animate-bounce shadow-lg" style={{ animationDelay: '0.5s', animationDuration: '2.5s' }}></div>
      <div className="absolute bottom-40 left-16 w-9 h-9 bg-green-300 border-4 border-black animate-bounce shadow-lg" style={{ animationDelay: '1s', animationDuration: '3.5s' }}></div>
      <div className="absolute top-1/3 right-12 w-7 h-7 bg-blue-300 border-4 border-black animate-bounce shadow-lg" style={{ animationDelay: '1.5s', animationDuration: '2s' }}></div>
      <div className="absolute bottom-24 right-32 w-8 h-8 bg-pink-300 border-4 border-black animate-bounce shadow-lg" style={{ animationDelay: '0.8s', animationDuration: '3s' }}></div>
      <div className="absolute top-1/2 left-8 w-6 h-6 bg-purple-300 border-4 border-black animate-bounce shadow-lg" style={{ animationDelay: '0.3s', animationDuration: '2.8s' }}></div>

      {/* Content */}
      <div className="relative z-10">
        <div className="container mx-auto px-4 py-6">
          <div className="max-w-2xl mx-auto">
            
            {/* Main Profile Card */}
            <div 
              className="bg-white relative"
              style={{
                border: '8px solid black',
                boxShadow: '12px 12px 0 rgba(0, 0, 0, 0.3)',
              }}
            >
              <div className="absolute top-0 left-0 w-6 h-6 bg-[#6fa85e]"></div>
              <div className="absolute top-0 right-0 w-6 h-6 bg-[#6fa85e]"></div>
              <div className="absolute bottom-0 left-0 w-6 h-6 bg-[#6fa85e]"></div>
              <div className="absolute bottom-0 right-0 w-6 h-6 bg-[#6fa85e]"></div>

              <div 
                className="py-3 border-b-6"
                style={{
                  background: 'linear-gradient(to right, #6fa85e, #8bc273)',
                  borderBottom: '6px solid black',
                }}
              >
                <h1 
                  className="text-2xl font-bold text-white text-center tracking-wider"
                  style={{
                    fontFamily: 'monospace',
                    textShadow: '3px 3px 0 rgba(0, 0, 0, 0.5)',
                  }}
                >
                  ◆ PROFILE SETTINGS ◆
                </h1>
              </div>

              <div className="p-8">
                {/* Avatar & Username */}
                <div className="flex flex-col items-center mb-6">
                  <div 
                    className="p-4 mb-4"
                    style={{
                      background: 'linear-gradient(135deg, #a8d88e, #8bc273)',
                      border: '4px solid black',
                      boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.2)',
                    }}
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      className="w-24 h-24 text-white"
                    >
                      <path
                        fillRule="evenodd"
                        d="M7.5 6a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM3.751 20.105a8.25 8.25 0 0116.498 0 .75.75 0 01-.437.695A18.683 18.683 0 0112 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 01-.437-.695z"
                        clipRule="evenodd"
                      />
                    </svg>
                  </div>

                  <h2 
                    className="text-2xl font-bold text-gray-800 mb-2"
                    style={{ fontFamily: 'monospace', letterSpacing: '0.1em' }}
                  >
                    {username.toUpperCase()}
                  </h2>

                  <div className="flex gap-1 mb-2">
                    <div className="w-2 h-2 bg-[#6fa85e]"></div>
                    <div className="w-2 h-2 bg-[#8bc273]"></div>
                    <div className="w-2 h-2 bg-[#a8d88e]"></div>
                  </div>
                </div>

                {/* Personal Info Section */}
                <div className="bg-gray-100 border-4 border-gray-800 p-4 mb-6">
                  <h3 
                    className="text-base font-bold mb-4 text-gray-800 flex items-center gap-2"
                    style={{ fontFamily: 'monospace' }}
                  >
                    <span>▶</span>
                    <span>PERSONAL INFORMATION</span>
                  </h3>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <InputField
                      label="WEIGHT"
                      value={weight}
                      onChange={setWeight}
                      unit="kg"
                      isEditing={isEditing}
                      type="number"
                    />
                    <InputField
                      label="HEIGHT"
                      value={height}
                      onChange={setHeight}
                      unit="cm"
                      isEditing={isEditing}
                      type="number"
                    />
                    <InputField
                      label="AGE"
                      value={age}
                      onChange={setAge}
                      unit="years"
                      isEditing={isEditing}
                      type="number"
                    />
                    <DropdownField
                      label="GENDER"
                      value={gender}
                      onChange={setGender}
                      options={['Male', 'Female']}
                      isEditing={isEditing}
                    />
                  </div>

                  <div className="mt-4">
                    <DropdownField
                      label="GOAL"
                      value={goal}
                      onChange={setGoal}
                      options={['Lose Weight', 'Maintain Weight', 'Gain Weight']}
                      isEditing={isEditing}
                    />
                  </div>
                </div>

                {/* Action Buttons */}
                {isEditing ? (
                  <div className="grid grid-cols-2 gap-4 mb-4">
                    <button
                      onClick={handleCancel}
                      className="py-4 bg-gray-800 text-white font-bold text-base border-4 border-black hover:bg-gray-700 transition"
                      style={{
                        fontFamily: 'monospace',
                        boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.3)',
                        textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)',
                      }}
                    >
                      ✗ CANCEL
                    </button>
                    <button
                      onClick={handleSave}
                      disabled={isLoading}
                      className="py-4 font-bold text-base text-white border-4 border-black disabled:opacity-50 hover:opacity-90 transition"
                      style={{
                        background: 'linear-gradient(to right, #6fa85e, #8bc273)',
                        fontFamily: 'monospace',
                        boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.3)',
                        textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)',
                      }}
                    >
                      {isLoading ? '⌛ SAVING...' : '✓ SAVE CHANGES'}
                    </button>
                  </div>
                ) : (
                  <div className="grid grid-cols-3 gap-3">
                    <button
                      onClick={handleBack}
                      className="py-4 bg-gray-800 text-white font-bold text-sm border-4 border-black hover:bg-gray-700 transition"
                      style={{
                        fontFamily: 'monospace',
                        boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.3)',
                        textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)',
                      }}
                    >
                      ◀ BACK
                    </button>
                    <button
                      onClick={handleEdit}
                      className="py-4 text-white font-bold text-sm border-4 border-black hover:opacity-90 transition"
                      style={{
                        background: 'linear-gradient(to right, #6fa85e, #8bc273)',
                        fontFamily: 'monospace',
                        boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.3)',
                        textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)',
                      }}
                    >
                      ✎ EDIT
                    </button>
                    <button
                      onClick={() => setShowLogoutModal(true)}
                      className="py-4 text-white font-bold text-sm border-4 border-black transition"
                      style={{
                        background: '#fb7185',
                        fontFamily: 'monospace',
                        boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.3)',
                        textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)',
                      }}
                    >
                      LOGOUT ▶
                    </button>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Modals */}
      {showSuccessModal && <SuccessModal onClose={() => setShowSuccessModal(false)} />}
      {showErrorModal && <ErrorModal message={errorMessage} onClose={() => setShowErrorModal(false)} />}
      {showLogoutModal && (
        <LogoutModal
          onCancel={() => setShowLogoutModal(false)}
          onConfirm={handleLogout}
        />
      )}
    </div>
  );
}

// Input Field Component
function InputField({ label, value, onChange, unit, isEditing, type = 'text' }: any) {
  return (
    <div>
      <label 
        className="block text-xs font-bold mb-1.5 text-gray-800"
        style={{ fontFamily: 'monospace' }}
      >
        {label} *
      </label>
      <div 
        className={`border-3 px-3 py-2.5 ${isEditing ? 'bg-white border-[#6fa85e]' : 'bg-gray-100 border-gray-800'}`}
        style={{ borderWidth: '3px' }}
      >
        {isEditing ? (
          <input
            type={type}
            value={value}
            onChange={(e) => onChange(e.target.value)}
            className="w-full bg-transparent text-sm text-gray-800"
            style={{ 
              fontFamily: 'monospace', 
              outline: 'none', 
              border: 'none', 
              boxShadow: 'none',
              appearance: 'none',
              WebkitAppearance: 'none',
              MozAppearance: 'none'
            }}
          />
        ) : (
          <span className="text-sm text-gray-800" style={{ fontFamily: 'monospace' }}>
            {value} {unit}
          </span>
        )}
      </div>
    </div>
  );
}

// Dropdown Field Component
function DropdownField({ label, value, onChange, options, isEditing }: any) {
  return (
    <div>
      <label 
        className="block text-xs font-bold mb-1.5 text-gray-800"
        style={{ fontFamily: 'monospace' }}
      >
        {label} *
      </label>
      <div 
        className={`border-3 px-3 py-2.5 ${isEditing ? 'bg-white border-[#6fa85e]' : 'bg-gray-100 border-gray-800'}`}
        style={{ borderWidth: '3px' }}
      >
        {isEditing ? (
          <select
            value={value}
            onChange={(e) => onChange(e.target.value)}
            className="w-full bg-transparent text-sm text-gray-800"
            style={{ 
              fontFamily: 'monospace', 
              outline: 'none', 
              border: 'none', 
              boxShadow: 'none',
              appearance: 'none',
              WebkitAppearance: 'none',
              MozAppearance: 'none'
            }}
          >
            {options.map((opt: string) => (
              <option key={opt} value={opt}>{opt}</option>
            ))}
          </select>
        ) : (
          <span className="text-sm text-gray-800" style={{ fontFamily: 'monospace' }}>
            {value.toUpperCase()}
          </span>
        )}
      </div>
    </div>
  );
}

// Success Modal
function SuccessModal({ onClose }: { onClose: () => void }) {
  return (
    <div className="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center p-4 z-50">
      <div 
        className="bg-white relative max-w-md w-full"
        style={{
          border: '8px solid black',
          boxShadow: '8px 8px 0 rgba(0, 0, 0, 0.5)',
          background: 'linear-gradient(180deg, #a8d88e, #8bc273)',
        }}
      >
        <div className="absolute top-0 left-0 w-4 h-4 bg-green-500"></div>
        <div className="absolute top-0 right-0 w-4 h-4 bg-green-500"></div>
        <div className="absolute bottom-0 left-0 w-4 h-4 bg-green-500"></div>
        <div className="absolute bottom-0 right-0 w-4 h-4 bg-green-500"></div>

        <div className="py-3 border-b-4 border-black bg-green-500">
          <h3 
            className="text-xl font-bold text-white text-center"
            style={{ fontFamily: 'monospace', textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)' }}
          >
            ★ SUCCESS! ★
          </h3>
        </div>

        <div className="p-8 text-center">
          {/* Success Icon */}
          <div className="flex justify-center mb-6">
            <div className="w-20 h-20 bg-green-500 border-4 border-black flex items-center justify-center">
              <div className="text-6xl text-white font-bold">✓</div>
            </div>
          </div>

          <div className="bg-white border-4 border-black p-4 mb-6">
            <p className="font-bold text-lg mb-2 text-gray-800" style={{ fontFamily: 'monospace' }}>
              PROFILE UPDATED!
            </p>
            <p className="text-sm text-gray-600" style={{ fontFamily: 'monospace' }}>
              Changes saved successfully!
            </p>
          </div>

          <button
            onClick={onClose}
            className="w-full py-3.5 text-white font-bold border-4 border-black"
            style={{
              background: 'linear-gradient(to right, #6fa85e, #8bc273)',
              fontFamily: 'monospace',
              boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.3)',
              textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)',
            }}
          >
            ▶ CONTINUE
          </button>
        </div>
      </div>
    </div>
  );
}

// Error Modal
function ErrorModal({ message, onClose }: { message: string; onClose: () => void }) {
  return (
    <div className="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center p-4 z-50">
      <div 
        className="bg-white relative max-w-md w-full"
        style={{
          border: '8px solid black',
          boxShadow: '8px 8px 0 rgba(0, 0, 0, 0.5)',
          background: 'linear-gradient(180deg, #fecaca, #fca5a5)',
        }}
      >
        <div className="absolute top-0 left-0 w-4 h-4 bg-red-600"></div>
        <div className="absolute top-0 right-0 w-4 h-4 bg-red-600"></div>
        <div className="absolute bottom-0 left-0 w-4 h-4 bg-red-600"></div>
        <div className="absolute bottom-0 right-0 w-4 h-4 bg-red-600"></div>

        <div className="py-3 border-b-4 border-black bg-red-600">
          <h3 
            className="text-xl font-bold text-white text-center"
            style={{ fontFamily: 'monospace', textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)' }}
          >
            ◆ ERROR ◆
          </h3>
        </div>

        <div className="p-8 text-center">
          <div className="flex justify-center mb-6">
            <div className="w-20 h-20 bg-red-600 border-4 border-black flex items-center justify-center">
              <div className="text-6xl text-white font-bold">!</div>
            </div>
          </div>

          <div className="bg-white border-4 border-black p-4 mb-6">
            <p className="font-bold text-lg mb-2 text-gray-800" style={{ fontFamily: 'monospace' }}>
              ERROR!
            </p>
            <p className="text-sm text-gray-600" style={{ fontFamily: 'monospace' }}>
              {message}
            </p>
          </div>

          <button
            onClick={onClose}
            className="w-full py-3.5 bg-red-600 text-white font-bold border-4 border-black"
            style={{
              fontFamily: 'monospace',
              boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.3)',
              textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)',
            }}
          >
            OK
          </button>
        </div>
      </div>
    </div>
  );
}

// Logout Modal
function LogoutModal({ onCancel, onConfirm }: { onCancel: () => void; onConfirm: () => void }) {
  return (
    <div className="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center p-4 z-50">
      <div 
        className="bg-white relative max-w-md w-full"
        style={{ border: '8px solid black', boxShadow: '8px 8px 0 rgba(0, 0, 0, 0.5)' }}
      >
        <div className="absolute top-0 left-0 w-4 h-4 bg-[#ff85c1]"></div>
        <div className="absolute top-0 right-0 w-4 h-4 bg-[#ff85c1]"></div>
        <div className="absolute bottom-0 left-0 w-4 h-4 bg-[#ff85c1]"></div>
        <div className="absolute bottom-0 right-0 w-4 h-4 bg-[#ff85c1]"></div>

        <div className="py-3 border-b-4 border-black" style={{ background: '#f6627bff' }}>
          <h3 
            className="text-xl font-bold text-white text-center"
            style={{ fontFamily: 'monospace', textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)' }}
          >
            ◆ WARNING ◆
          </h3>
        </div>

        <div className="p-8 text-center">
          {/* Warning Icon */}
          <div className="flex justify-center mb-6">
            <div className="w-20 h-20 border-4 border-black flex items-center justify-center" style={{ background: '#f6627bff' }}>
              <div className="text-6xl text-white font-bold">?</div>
            </div>
          </div>

          <p className="text-sm mb-6 text-gray-800 font-bold" style={{ fontFamily: 'monospace' }}>
            DO YOU WANT TO<br />LOG OUT?
          </p>

          <div className="flex justify-center gap-1.5 mb-6">
            <div className="w-2 h-2 border border-black" style={{ background: '#f6627bff' }}></div>
            <div className="w-2 h-2 border border-black" style={{ background: '#f6627bff' }}></div>
            <div className="w-2 h-2 border border-black" style={{ background: '#f6627bff' }}></div>
          </div>

          <div className="flex justify-center gap-4 text-center">

            <button
              onClick={onCancel}
              className="flex-1 py-3.5 bg-gray-800 text-white font-bold text-sm border-4 border-black hover:bg-gray-700 transition"
              style={{
                fontFamily: 'monospace',
                boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.3)',
                textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)',
              }}
            >
              CANCEL
            </button>
            <button
              onClick={onConfirm}
              className="flex-1 py-3.5 text-white font-bold text-sm border-4 border-black transition"
              style={{
                background: '#f6627bff',
                fontFamily: 'monospace',
                boxShadow: '4px 4px 0 rgba(0, 0, 0, 0.3)',
                textShadow: '2px 2px 0 rgba(0, 0, 0, 0.5)',
              }}
            >
              LOGOUT
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}