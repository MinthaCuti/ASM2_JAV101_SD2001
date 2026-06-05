<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verdelle Hotel - Đặt phòng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col justify-between relative">

<div class="flex flex-col flex-grow justify-between">
    <header class="bg-black text-white px-4 py-3 flex justify-between items-center shadow-md">
        <div class="flex items-center space-x-2">
            <div class="text-xl font-serif italic font-bold tracking-wider">Verdelle <br><span class="text-xs uppercase tracking-widest block -mt-1">Hotel</span></div>
        </div>
        <nav class="hidden md:flex space-x-8 font-medium text-sm">
            <a href="#" class="hover:text-blue-400 transition">Trang chủ</a>
            <a href="#" class="hover:text-blue-400 transition">Phòng</a>
            <a href="#" class="hover:text-blue-400 transition">Liên hệ</a>
        </nav>
        <div class="flex items-center space-x-3">
            <img src="https://via.placeholder.com/32" alt="Avatar" class="w-8 h-8 rounded-full border border-gray-400">
            <div class="text-xs hidden sm:block">
                <p class="font-semibold">Verdelle Mintha</p>
                <p class="text-gray-400 text-[10px]">Điểm: N/A</p>
            </div>
        </div>
    </header>

    <div class="bg-gray-300 text-xs md:text-sm text-gray-600 py-3 shadow-inner">
        <div class="max-w-5xl mx-auto px-4 flex justify-between items-center relative">
            <div class="absolute left-0 right-0 top-1/2 h-0.5 bg-blue-500 z-0 mx-12 hidden md:block"></div>
            <div class="z-10 flex flex-col items-center flex-1 text-blue-600 font-bold">
                <span class="w-5 h-5 bg-blue-600 text-white rounded-full flex items-center justify-center text-[10px] mb-1">1</span>
                <span>Thông tin khách hàng</span>
            </div>
            <div class="z-10 flex flex-col items-center flex-1 text-gray-500">
                <span class="w-5 h-5 bg-gray-400 text-white rounded-full flex items-center justify-center text-[10px] mb-1">2</span>
                <span>Chi tiết thanh toán</span>
            </div>
            <div class="z-10 flex flex-col items-center flex-1 text-gray-500">
                <span class="w-5 h-5 bg-gray-400 text-white rounded-full flex items-center justify-center text-[10px] mb-1">3</span>
                <span>Hoàn thành đặt chỗ</span>
            </div>
        </div>
    </div>

    <main class="max-w-5xl w-full mx-auto p-4 grid grid-cols-1 md:grid-cols-3 gap-6 flex-grow">
        <div class="md:col-span-2 space-y-5">
            <div class="bg-white p-5 rounded-xl border border-gray-300 shadow-sm relative">
                <h2 class="text-lg font-bold text-gray-800 mb-3">Khách chính</h2>
                <div class="flex items-start space-x-3">
                    <div class="text-gray-600 mt-1"><i class="fa-solid fa-circle-user text-xl"></i></div>
                    <div>
                        <p id="display-name" class="font-bold text-gray-900 text-base">Verdelle Mintha</p>
                        <p id="display-email" class="text-gray-500 text-sm">VerdelleMintha@gmail.com</p>
                        <p id="display-phone" class="text-gray-500 text-sm">+ 84 834178906</p>
                    </div>
                </div>
                <button id="btn-edit" class="absolute bottom-4 right-4 text-xs text-blue-600 underline font-medium hover:text-blue-800 focus:outline-none">Chỉnh sửa</button>
            </div>

            <div class="bg-white p-5 rounded-xl border border-gray-300 shadow-sm">
                <h2 class="text-lg font-bold text-gray-800">Yêu cầu đặc biệt</h2>
                <p class="text-xs text-gray-400 mb-4">Theo sở thích của quý khách</p>
                <div class="space-y-3">
                    <label class="flex items-center space-x-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 text-blue-600 rounded border-gray-300">
                        <div class="w-6 h-6 bg-gray-200 rounded flex items-center justify-center text-gray-400 text-xs"><i class="fa-regular fa-image"></i></div>
                        <span class="w-32 h-3 bg-gray-200 rounded"></span>
                    </label>
                    <label class="flex items-center space-x-3 cursor-pointer">
                        <input type="checkbox" class="w-4 h-4 text-blue-600 rounded border-gray-300">
                        <div class="w-6 h-6 bg-gray-200 rounded flex items-center justify-center text-gray-400 text-xs"><i class="fa-regular fa-image"></i></div>
                        <span class="w-40 h-3 bg-gray-200 rounded"></span>
                    </label>
                </div>
            </div>

            <div class="bg-white p-5 rounded-xl border border-green-600 shadow-sm space-y-4">
                <h2 class="text-base font-bold text-green-700">Quyền lợi phòng miễn phí</h2>
                <div class="flex items-center justify-between border-b pb-3 border-gray-100">
                    <div class="flex items-center space-x-3">
                        <div class="text-blue-500 text-xl"><i class="fa-solid fa-wifi"></i></div>
                        <div><p class="font-bold text-sm text-gray-800">Wifi miễn phí</p></div>
                    </div>
                    <span class="bg-green-700 text-white text-xs px-2.5 py-1 rounded font-bold">Bao gồm</span>
                </div>
            </div>
        </div>

        <div class="space-y-5">
            <div class="bg-white p-4 rounded-xl border border-gray-300 shadow-sm flex justify-between items-center text-center">
                <div class="flex-1"><p class="text-[10px] text-gray-400 uppercase">Nhận phòng</p><p class="text-base font-bold text-gray-700">dd/mm/yy</p></div>
                <div class="text-gray-400 px-2"><i class="fa-solid fa-arrow-right"></i></div>
                <div class="flex-1"><p class="text-[10px] text-gray-400 uppercase">Trả phòng</p><p class="text-base font-bold text-gray-700">dd/mm/yy</p></div>
            </div>
            <div class="bg-white p-4 rounded-xl border border-black shadow-sm space-y-3">
                <div class="flex justify-between items-baseline">
                    <span class="text-sm font-bold text-gray-800">Giá cuối cùng</span>
                    <span class="text-lg font-black text-gray-900">X.XXX.XXX</span>
                </div>
            </div>
        </div>
    </main>

    <footer class="bg-zinc-900 text-gray-400 text-xs py-4 text-center border-t border-zinc-800">
        <p>&copy; 2026 Designed by Verdelle Mintha</p>
    </footer>
</div>


<div id="modal-edit" class="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50 hidden">

    <div id="modal-card" class="bg-white w-full max-w-2xl rounded-2xl p-6 shadow-2xl relative border border-gray-200">

        <div class="mb-5">
            <h3 class="text-xl font-bold text-gray-900 inline-block">Ai là khách chính?</h3>
            <span class="text-xs text-gray-400 ml-2 block sm:inline">Vui lòng đảm bảo thông tin liên hệ của quý khách là chính xác.</span>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">

            <div class="relative border-2 border-green-600 focus-within:border-green-700 rounded-xl px-3 py-1 bg-white">
                <label class="absolute -top-2.5 left-3 bg-white px-1 text-[11px] font-semibold text-green-600">Tên *</label>
                <input type="text" id="input-name" placeholder="Nhập" class="w-full pt-1.5 pb-1 text-sm text-gray-800 placeholder-gray-300 focus:outline-none bg-transparent">
            </div>

            <div class="relative border-2 border-green-600 focus-within:border-green-700 rounded-xl px-3 py-1 bg-white">
                <label class="absolute -top-2.5 left-3 bg-white px-1 text-[11px] font-semibold text-green-600">Quốc gia cư trú *</label>
                <input type="text" id="input-residence" placeholder="Nhập" value="Vietnam" class="w-full pt-1.5 pb-1 text-sm text-gray-800 placeholder-gray-300 focus:outline-none bg-transparent">
            </div>

            <div class="relative border-2 border-green-600 focus-within:border-green-700 rounded-xl px-3 py-1 bg-white">
                <label class="absolute -top-2.5 left-3 bg-white px-1 text-[11px] font-semibold text-green-600">Họ *</label>
                <input type="text" id="input-surname" placeholder="Nhập" class="w-full pt-1.5 pb-1 text-sm text-gray-800 placeholder-gray-300 focus:outline-none bg-transparent">
            </div>

            <div class="grid grid-cols-3 gap-2">
                <div class="relative border-2 border-green-600 rounded-xl px-2 py-1 bg-white col-span-1 flex items-center justify-between">
                    <label class="absolute -top-2.5 left-2 bg-white px-1 text-[10px] font-semibold text-green-600">Country</label>
                    <span class="text-xs font-bold text-gray-700 pt-1">+ 84</span>
                    <i class="fa-solid fa-chevron-down text-gray-400 text-[10px] pt-1"></i>
                </div>
                <div class="relative border-2 border-green-600 focus-within:border-green-700 rounded-xl px-3 py-1 bg-white col-span-2">
                    <label class="absolute -top-2.5 left-3 bg-white px-1 text-[11px] font-semibold text-green-600">Số điện thoại</label>
                    <input type="tel" id="input-phone" placeholder="Nhập" class="w-full pt-1.5 pb-1 text-sm text-gray-800 placeholder-gray-300 focus:outline-none bg-transparent">
                </div>
            </div>

            <div class="relative border-2 border-green-600 focus-within:border-green-700 rounded-xl px-3 py-1 bg-white sm:col-span-2 mt-2">
                <label class="absolute -top-2.5 left-3 bg-white px-1 text-[11px] font-semibold text-green-600">Email ID *</label>
                <input type="email" id="input-email" placeholder="Nhập" class="w-full pt-1.5 pb-1 text-sm text-gray-800 placeholder-gray-300 focus:outline-none bg-transparent">
            </div>
        </div>

        <div class="mt-5 flex items-start space-x-3">
            <input type="checkbox" id="check-save" class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-500 mt-0.5 cursor-pointer">
            <label for="check-save" class="text-xs text-gray-500 leading-tight cursor-pointer select-none">
                Lưu thông tin khách để thanh toán nhanh hơn cho lần sau. Xem
                <a href="#" class="text-blue-600 underline font-medium">Chính sách Quyền riêng tư.</a>
            </label>
        </div>

    </div>
</div>


<script>
    const btnEdit = document.getElementById('btn-edit');
    const modalEdit = document.getElementById('modal-edit');
    const modalCard = document.getElementById('modal-card');

    const inputName = document.getElementById('input-name');
    const inputSurname = document.getElementById('input-surname');
    const inputPhone = document.getElementById('input-phone');
    const inputEmail = document.getElementById('input-email');

    const displayName = document.getElementById('display-name');
    const displayEmail = document.getElementById('display-email');
    const displayPhone = document.getElementById('display-phone');

    // Bấm Chỉnh sửa -> Hiện Form Popup và đồng bộ thông tin cũ vào ô nhập
    btnEdit.addEventListener('click', (e) => {
        e.stopPropagation();

        const currentFullName = displayName.innerText.trim().split(' ');
        if (currentFullName.length >= 2) {
            inputSurname.value = currentFullName[0];
            inputName.value = currentFullName.slice(1).join(' ');
        } else {
            inputName.value = displayName.innerText;
            inputSurname.value = '';
        }

        inputEmail.value = displayEmail.innerText.trim();
        inputPhone.value = displayPhone.innerText.replace('+ 84 ', '').trim();

        modalEdit.classList.remove('hidden');
    });

    // Hàm xử lý lưu thông tin mới và đóng Popup
    function saveAndCloseModal() {
        const newFullName = `${inputSurname.value.trim()} ${inputName.value.trim()}`.trim();

        if (newFullName) displayName.innerText = newFullName;
        if (inputEmail.value.trim()) displayEmail.innerText = inputEmail.value.trim();
        if (inputPhone.value.trim()) {
            displayPhone.innerText = `+ 84 ${inputPhone.value.trim()}`;
        }

        modalEdit.classList.add('hidden');
    }

    // CLICK RA NGOÀI KHUNG TRẮNG -> TỰ ĐỘNG LƯU VÀ ĐÓNG POPUP QUAY VỀ MÀN HÌNH CHÍNH
    modalEdit.addEventListener('click', (e) => {
        if (!modalCard.contains(e.target)) {
            saveAndCloseModal();
        }
    });
</script>
</body>
</html>