// День 1. Гостиница «Виктория», фойе. Хозяйка.
// Дальше: day1_hotel_floor.ink

# story: hotel_lobby

-> lobby

=== lobby ===
Закрывай, закрывай, чего встал! # window:default # char:landlady # anim:hostile # skippable:false
Дверь захлопывается за твоей спиной. # thought
Сильнейший сквозняк пронесся по стойке ресепшена и перелистал страницы журнала. # thought
Прическе хозяйки, замечаешь ты, тоже досталось. Или тут дело не в сквозняке? # thought
В лифте родился? # char:landlady # skippable:false
Остановиться можно? Почем? # response # char:detective # skippable:false
Две двести. Удобства общие в коридоре. # char:landlady # skippable:false
Вверх по лестнице, второй номер справа. # char:landlady # skippable:false
С завтраком? # response # char:detective # skippable:false
Ага, щас. А больше ниче не надо? # char:landlady # anim:annoyed # skippable:false
У вас водитель остановился. Семён. # response # char:detective # skippable:false
В двести четвертом. # char:landlady # anim:eye_roll # skippable:false
Передай, если снова в номере курить будет — выкину на мороз к чер-ртовой бабушке. # char:landlady # skippable:false
-> END
