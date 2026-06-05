<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html lang="eng">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verdelle Hotel - Đặt phòng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="css/HeaderStyle.css">
    <link rel="stylesheet" href="css./NavStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col justify-between">
<header>
    <jsp:include page="header.jsp" />
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
                    <p class="font-bold text-gray-900 text-base">Verdelle Mintha</p>
                    <p class="text-gray-500 text-sm">VerdelleMintha@gmail.com</p>
                    <p class="text-gray-500 text-sm">+ 84 834178906</p>
                </div>
            </div>
            <a href="#" class="absolute bottom-4 right-4 text-xs text-blue-600 underline font-medium">Chỉnh sửa</a>
        </div>

        <div class="bg-white p-5 rounded-xl border border-gray-300 shadow-sm">
            <h2 class="text-lg font-bold text-gray-800">Yêu cầu đặc biệt</h2>
            <p class="text-xs text-gray-400 mb-4">Theo sở thích của quý khách</p>

            <div class="space-y-3">
                <label class="flex items-center space-x-3 cursor-pointer">
                    <input type="checkbox" class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-500">
                    <div class="w-6 h-6 bg-gray-200 rounded flex items-center justify-center text-gray-400 text-xs"><i class="fa-regular fa-image"></i></div>
                    <span class="w-32 h-3 bg-gray-200 rounded"></span>
                </label>
                <label class="flex items-center space-x-3 cursor-pointer">
                    <input type="checkbox" class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-500">
                    <div class="w-6 h-6 bg-gray-200 rounded flex items-center justify-center text-gray-400 text-xs"><i class="fa-regular fa-image"></i></div>
                    <span class="w-40 h-3 bg-gray-200 rounded"></span>
                </label>
                <label class="flex items-center space-x-3 cursor-pointer">
                    <input type="checkbox" class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-500">
                    <div class="w-6 h-6 bg-gray-200 rounded flex items-center justify-center text-gray-400 text-xs"><i class="fa-regular fa-image"></i></div>
                    <span class="w-24 h-3 bg-gray-200 rounded"></span>
                </label>
            </div>
        </div>

        <div class="bg-white p-5 rounded-xl border border-green-600 shadow-sm space-y-4">
            <h2 class="text-base font-bold text-green-700">Quyền lợi phòng miễn phí</h2>

            <div class="flex items-center justify-between border-b pb-3 border-gray-100">
                <div class="flex items-center space-x-3">
                    <div class="text-blue-500 text-xl"><i class="fa-solid fa-calendar-check"></i></div>
                    <div>
                        <p class="font-bold text-sm text-gray-800">Hoàn tiền toàn bộ</p>
                        <p class="text-[11px] text-gray-400">Hủy miễn phí trước N/A Tháng N/A, yyyy</p>
                    </div>
                </div>
                <span class="bg-green-700 text-white text-xs px-2.5 py-1 rounded font-bold">Bao gồm</span>
            </div>

            <div class="flex items-center justify-between border-b pb-3 border-gray-100">
                <div class="flex items-center space-x-3">
                    <div class="text-blue-500 text-xl"><i class="fa-solid fa-wifi"></i></div>
                    <div>
                        <p class="font-bold text-sm text-gray-800">Wifi miễn phí</p>
                    </div>
                </div>
                <span class="bg-green-700 text-white text-xs px-2.5 py-1 rounded font-bold">Bao gồm</span>
            </div>

            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-3">
                    <div class="text-blue-500 text-xl"><i class="fa-solid fa-square-p"></i></div>
                    <div>
                        <p class="font-bold text-sm text-gray-800">Bãi đậu xe</p>
                    </div>
                </div>
                <span class="bg-green-700 text-white text-xs px-2.5 py-1 rounded font-bold">Bao gồm</span>
            </div>
        </div>

        <div class="bg-white p-4 rounded-xl border border-gray-300 shadow-sm text-center">
            <button class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-lg transition text-sm">
                Tiếp theo: Xem lại và xác nhận
            </button>
            <p class="text-xs text-blue-500 mt-2">Chưa tính phí ở bước này</p>
        </div>

    </div>

    <div class="space-y-5">

        <div class="bg-white p-4 rounded-xl border border-gray-300 shadow-sm flex justify-between items-center text-center">
            <div class="flex-1">
                <p class="text-[10px] text-gray-400 uppercase">Nhận phòng</p>
                <p class="text-base font-bold text-gray-700">dd/mm/yy</p>
            </div>
            <div class="text-gray-400 px-2"><i class="fa-solid fa-arrow-right"></i></div>
            <div class="flex-1">
                <p class="text-[10px] text-gray-400 uppercase">Trả phòng</p>
                <p class="text-base font-bold text-gray-700">dd/mm/yy</p>
            </div>
        </div>

        <div class="bg-white p-4 rounded-xl border border-gray-300 shadow-sm space-y-3">
            <h2 class="text-base font-bold text-gray-800">Khách sạn "N/A"</h2>
            <div class="flex text-yellow-400 text-xs">
                <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
            </div>

            <div class="bg-blue-50/50 border border-blue-100 rounded-lg p-3 space-y-3">
                <div class="flex space-x-3">
                    <div class="w-16 h-16 bg-gray-200 rounded flex items-center justify-center text-gray-400 text-lg flex-shrink-0">
                        <i class="fa-regular fa-image"></i>
                    </div>
                    <div>
                        <p class="font-bold text-xs text-gray-800">1x Phòng "N/A"...</p>
                        <p class="text-[11px] text-gray-400 mt-1">Diện tích: N/A m²</p>
                        <p class="text-[11px] text-gray-400">Gồm N/A giường đôi<br>N/A giường đơn</p>
                    </div>
                </div>
                <div class="text-green-700 text-xs flex items-center space-x-1.5 pt-2 border-t border-blue-100">
                    <i class="fa-solid fa-suitcase-rolling"></i>
                    <span>Có chỗ giữ hành lý</span>
                </div>
            </div>
        </div>

        <div class="bg-green-100 text-green-800 p-3 rounded-xl flex items-center space-x-3 text-xs font-semibold">
            <div class="text-lg"><i class="fa-solid fa-thumbs-up"></i></div>
            <div>
                <p class="font-bold text-green-900">Lựa chọn khách sạn tốt nhất</p>
                <p class="text-green-700 font-normal">Đánh giá trung bình của khách 8,5</p>
            </div>
        </div>

        <div class="text-center text-[11px] text-green-700 bg-green-50 py-2 px-3 rounded-lg border border-green-200">
            Chúng tôi khớp giá. Quý khách tiết kiệm được <span class="font-bold">XXX.XXX đ</span> với đơn này!
        </div>

        <div class="bg-white p-4 rounded-xl border border-black shadow-sm space-y-3 relative overflow-hidden">
            <div class="absolute top-3 right-3 bg-red-600 text-white text-xs font-bold px-3 py-1 rounded">
                Giảm 30%
            </div>

            <div class="text-xs space-y-2 pt-6">
                <div class="flex justify-between text-gray-500">
                    <span>Giá gốc (N/A phòng x N/A đêm)</span>
                    <span class="line-through">X.XXX.XXX đ</span>
                </div>
                <div class="flex justify-between font-medium text-gray-800">
                    <span>Giá phòng (1 phòng x 1 đêm)</span>
                    <span>X.XXX.XXX đ</span>
                </div>
                <div class="flex justify-between text-gray-500">
                    <span>Thuế và phí</span>
                    <span>XXX.XXX đ</span>
                </div>
                <div class="flex justify-between text-blue-600 font-semibold">
                    <span>Phí đặt trước</span>
                    <span>MIỄN PHÍ</span>
                </div>
            </div>

            <div class="border-t pt-3 flex justify-between items-baseline">
                <div>
                    <p class="text-sm font-bold text-gray-800">Giá cuối cùng</p>
                    <p class="text-[10px] text-gray-400">Giá đã bao gồm VAT: XXX.XXX đ</p>
                </div>
                <span class="text-lg font-black text-gray-900">X.XXX.XXX</span>
            </div>
        </div>

    </div>
</main>

<jsp:include page="footer.jsp" />

</body>
</html>