// День 1. Остановка. Разведчик провожает до гостиницы «Виктория».
// Персонажи: scout, detective.
// detective_alias: scout / serega / sergey

# load: detective_alias
# save: detective_alias

VAR detective_alias = ""

-> meet

=== meet ===
Ты толстый. # window:default # char:scout # anim:teasing
* [Это чтоб не мерзнуть.]
	Это чтоб не мерзнуть. # response # char:detective
	-> after_fat
* [Не такой уж и толстый.]
	Не такой уж и толстый. # response # char:detective
	-> after_fat
* [А ты чмошник.]
	А ты чмошник. # response # char:detective
	-> after_fat

=== after_fat ===
Разведчик смеется. # char:scout # anim:laugh
Скажи лучше, где у вас гостиница? # response # char:detective
Так я тебе прям все и сказал. Дашь полтос? # char:scout
Сам найду. # response # char:detective
Постой, дядь! Я ж пошутил немножко. Немножко пошутил. Пойдем вместе. # char:scout
Ну веди. # response # char:detective
Как звать-то тебя? # response # char:detective
Я Разведчик. А ты? # char:scout
Угу. А на самом деле? # response # char:detective
Я на задании. В инкогнито. # char:scout
А тебя? # char:scout
* [Сыщик.]
	Сыщик. # response # char:detective
	~ detective_alias = "scout"
	Разведчик старается не подавать вида, но он явно впечатлен. # char:scout # anim:impressed
	-> after_name
* [Серега.]
	Серега. # response # char:detective
	~ detective_alias = "serega"
	Разведчик кивает. # char:scout # anim:nod
	-> after_name
* [Сергей Степанович.]
	Сергей Степанович. # response # char:detective
	~ detective_alias = "sergey"
	Разведчик кивает. # char:scout # anim:nod
	-> after_name

=== after_name ===
А ты чего на остановке стоял? Ждал кого-то? # response # char:detective
Следил. # char:scout
За кем? # response # char:detective
За обстановкой. Разведчик всегда должен быть начеку. # char:scout
И как обстановка, мгм, на остановке? # response # char:detective
Это засекреченная информация. # char:scout
Тебя не проведешь, я смотрю. # response # char:detective
Угу. # char:scout # anim:stern
Вид у него очень суровый.
А ты зачем приехал? # char:scout
Ищу кое-кого. Ты, кстати, можешь мне помочь. Не знаешь вот этого пацана? # response # char:detective
Разведчик изучает фото с непроницаемым лицом. # char:scout # anim:blank
Пока не знаю. # char:scout
И что это значит? # response # char:detective
Пока не скажу. # char:scout
Колись. # response # char:detective
А то что? # char:scout # anim:defiant
Разведчик смотрит с вызовом.
* [А то маме расскажу.]
	А то маме расскажу. # response # char:detective
	-> flees
* [Да ничего. Думал, два профессионала смогут найти общий язык, если уж дело серьезное.]
	Да ничего. Думал, два профессионала смогут найти общий язык, если уж дело серьезное. # response # char:detective
	-> serious
* [А то пойдешь со мной в полицию, будешь сидеть в наручниках.]
	А то пойдешь со мной в полицию, будешь сидеть в наручниках. # response # char:detective
	-> cuffs

=== flees ===
Ну да. Своей маме еще расскажи. Умник! По горшкам дежурник! # window:default # char:scout # anim:mocking
Разведчик корчит рожу и в следующий миг ныряет под теплотрассу, подтягивая штаны. # char:scout # anim:escape
// Дальше детектив ищет гостиницу сам. В сценарии эта ветка не прописана.
-> END

=== serious ===
Раз серьезное… # window:default # char:scout # anim:serious
Разведчик пристально смотрит на тебя.
Раз серьезное… # char:scout
-> walk

=== cuffs ===
Разведчик будто этого и ждал. Он протягивает руки и верещит. # window:default # char:scout # anim:frantic
Убей не скажу! Вяжи, мент позорный! # char:scout
Женщина на другой стороне улицы оборачивается на вас с Разведчиком и тычет локтем мужчину с пакетами, идущего рядом с ней.
Этого еще не хватало.
Хорош уже. Перестань визжать. Я же не взаправду. # response # char:detective
Будешь знать. # char:scout # anim:smug
А парень не промах. Блефовать тоже надо уметь.
-> walk

=== walk ===
За снежной крошкой и белым туманом даже соседние дома еле видно. Чтобы найти обратный путь до остановки, тебе пришлось бы приложить кучу усилий. Потеряться в таких условиях легче легкого, а вот искать что-то или кого-то — уже задача со звездочкой. Дело будет труднее, чем казалось еще час назад. # window:default
Давно у вас погода такая? Не видно ни черта. # response # char:detective
А у нас всю зиму так. А вчера еще хуже стало. # char:scout
Значит, когда Женя приехал, видимость была получше. Это хорошо.
Остальной путь мы проделали молча. Вскоре показалась неоновая вывеска «ВИКТОРИЯ», а следом и само коренастое двухэтажное здание.
Пришли. Может, дашь полтос все-таки? # char:scout
Бери, заслужил. А если про пацана с фотки чего вспомнишь — заходи на огонек. # response # char:detective
Разведчик выхватывает полтинник и убегает, не попрощавшись.
Брррррррррр! # char:scout # anim:shiver
Он скрывается в тумане, издавая звуки снегохода.
Ты с усилием открываешь дверь гостиницы и заходишь внутрь.
-> END
