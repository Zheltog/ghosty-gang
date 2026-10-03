// День 1. Гостиница «Виктория», фойе. Хозяйка.
// Дальше: day1_hotel_floor.ink

# story: hotel_lobby

-> lobby

=== lobby ===
Закрывай, закрывай, чего встал! # window:default # char:landlady # anim:hostile
Дверь захлопывается за твоей спиной. # thought
Сильнейший сквозняк пронесся по стойке ресепшена и перелистал страницы журнала. # thought
Прическе хозяйки, замечаешь ты, тоже досталось. Или тут дело не в сквозняке? # thought
В лифте родился? # char:landlady
Остановиться можно? Почем? # response # char:detective
Две двести. Удобства общие в коридоре. # char:landlady
Вверх по лестнице, второй номер справа. # char:landlady
С завтраком? # response # char:detective
Ага, щас. А больше ниче не надо? # char:landlady # anim:annoyed
У вас водитель остановился. Семён. # response # char:detective
В двести четвертом. # char:landlady # anim:eye_roll
Передай, если снова в номере курить будет — выкину на мороз к чер-ртовой бабушке. # char:landlady
-> END
