// День 1. Прибытие к гостинице «Виктория», знакомство с Инженером.
// Персонажи: scout, detective, engineer.
// Мысли и ремарки — # thought, их говорит none.

// TODO: уточнить позы/эмоции.

# story: hotel_outside

-> meet_engineer

== meet_engineer ==
Знаешь его? # response # char:detective # skippable:false
Эй, Инженер! Инженер! Приве-е-ет! # char:scout # skippable:false
Добрый день. Разведчик, не познакомишь нас? # char:engineer # skippable:false
Пусть сам представляется! # char:scout # skippable:false
Это невежливо. Настоящий разведчик должен иметь хорошие манеры. # char:engineer # skippable:false
Чтобы прилично вести себя в тылу врага? # char:scout # skippable:false
Можно и так сказать. # char:engineer # skippable:false
Владислав. Инженер, как вы могли догадаться. На пенсии, правда. # char:engineer # skippable:false
А я Сергей. Следователь. В отставке. # response # char:detective # skippable:false
Как интересно! Я вас раньше тут не встречал. # char:engineer # skippable:false
Я не местный. По делам приехал. Ищу кое-кого. # response # char:detective # skippable:false
Неужели? Могу я вам чем-то помочь? # char:engineer # skippable:false
Возможно. Вы видели этого мальчика? # response # char:detective # skippable:false
Ну? # response # char:detective # skippable:false
Да, я видел его. Когда это было?.. Дня три назад. # char:engineer # skippable:false
Нет, вру: днем позже. Позавчера. Правда, мельком и издалека. # char:engineer # skippable:false
Значит, мальчик все-таки в Вязи. Прекрасные новости. # thought
Знали его лично? # response # char:detective # skippable:false
Немного. # char:engineer # skippable:false
У вас будет время поговорить об этом подробнее? # response # char:detective # skippable:false
Конечно. Только, боюсь, не сейчас: очень спешу. # char:engineer # skippable:false
В таком случае, могу я взять ваш телефон? # response # char:detective # skippable:false
Лучше запишу свой адрес. В такую пургу все равно не дозвонитесь. Нет связи. # char:engineer # skippable:false
Давайте адрес. Если что - я остановлюсь в гостинице, можете найти меня здесь. # response # char:detective # skippable:false
Вот и договорились. # char:engineer # skippable:false
Дядь Инженер, а можно я тоже к тебе приду послушать? # char:scout # skippable:false
Да там и слушать нечего. # char:engineer # skippable:false
Кстати, Разведчик, а как ты познакомился с нашим новым другом? # char:engineer # skippable:false
Так он на остановке потерялся. Спрашивал отель. Ну я и решил, это самое, довести. # char:scout # skippable:false
Довести уж ты кого угодно можешь. # char:engineer # skippable:false
Ну а я о чем. # char:scout # skippable:false
Ты разве не знаешь, что на улице с незнакомцами нельзя говорить? # char:engineer # skippable:false
Так он вроде ниче, сам видишь. # char:scout # skippable:false
Мало ли кто мог оказаться!.. # char:engineer # skippable:false
Вы уж извините. # char:engineer # skippable:false
Все правильно говорите. Мало ли кто. Ты, пацан, аккуратнее будь. # response # char:detective # skippable:false
Ну ладно. Я побежал. Вы, Сергей, найдите меня попозже. # char:engineer # skippable:false
Найду. Еще раз спасибо. # response # char:detective # skippable:false
И тебе, пацан, спасибо, что довел. # response # char:detective # skippable:false
Брррррррррр! # char:scout # skippable:false
-> END
