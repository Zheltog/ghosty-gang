// День 1. Возвращение в гостиницу «Виктория», фойе. Хозяйка.
// Персонажи: landlady, detective.
// Мысли и ремарки — # thought, их говорит none.
// Дальше: day1_hotel_sleep.ink

// TODO: уточнить позы/эмоции.

# story: hotel_returning

-> lobby_again

=== lobby_again ===
Ты возвращаешься в “Викторию”. # window:default # thought
Хозяйка за стойкой ест быстрозавариваемое пюре, в которое крупно нарезана сосиска. # thought # char:landlady
* [Пожелать приятного аппетита]
    Приятного аппетита. # response # char:detective # skippable:false
    Шпашибо. # window:default # char:landlady # skippable:false
    Хозяйка не поднимает головы и не утруждается тщательным прожёвыванием пищи. # thought # char:landlady
    Она явно не настроена сейчас разговаривать. # thought
    -> END
* [Пройти мимо]
    -> END
