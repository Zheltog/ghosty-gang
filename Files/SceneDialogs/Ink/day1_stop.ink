// День 1. Остановка. Разведчик провожает до гостиницы «Виктория».
// Персонажи: scout, detective.
// detective_alias: scout / serega / sergey
// Мысли и ремарки — # thought, их говорит none.

# story: stop
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
Скажи лучше, где у вас гостиница? # response # char:detective
Так я тебе прям все и сказал. # char:scout # anim:laugh
Дашь полтос? # char:scout
Сам найду. # response # char:detective
Постой, дядь! Я ж пошутил немножко. # char:scout
Немножко пошутил. Пойдем вместе. # char:scout
Ну веди. # response # char:detective
Как звать-то тебя? # response # char:detective
Я Разведчик. А ты? # char:scout # introduced
Угу. А на самом деле? # response # char:detective
Я на задании. В инкогнито. # char:scout
А тебя? # char:scout
* [Сыщик.]
	Сыщик. # response # char:detective
	~ detective_alias = "scout"
	-> after_name
* [Серега.]
	Серега. # response # char:detective
	~ detective_alias = "serega"
	-> after_name
* [Сергей Степанович.]
	Сергей Степанович. # response # char:detective
	~ detective_alias = "sergey"
	-> after_name

=== after_name ===
А ты чего на остановке стоял? Ждал кого-то? # response # char:detective
{detective_alias == "scout":
	Следил. # char:scout # anim:impressed
- else:
	Следил. # char:scout # anim:nod
}
За кем? # response # char:detective
За обстановкой. # char:scout
Разведчик всегда должен быть начеку. # char:scout
И как обстановка, мгм, на остановке? # response # char:detective
Это засекреченная информация. # char:scout
Тебя не проведешь, я смотрю. # response # char:detective
Угу. # char:scout # anim:stern
А ты зачем приехал? # char:scout
Ищу кое-кого. Ты, кстати, можешь мне помочь. # response # char:detective
Не знаешь вот этого пацана? # response # char:detective
Пока не знаю. # char:scout # anim:blank
И что это значит? # response # char:detective
Пока не скажу. # char:scout
Колись. # response # char:detective
А то что? # char:scout # anim:defiant
* [А то маме расскажу.]
	А то маме расскажу. # response # char:detective
	-> flees
* [Да ничего.]
	Да ничего. # response # char:detective
	Думал, два профессионала смогут найти общий язык, если уж дело серьезное. # response # char:detective
	-> serious
* [А то пойдешь со мной в полицию.]
	А то пойдешь со мной в полицию. # response # char:detective
	Будешь сидеть в наручниках. # response # char:detective
	-> cuffs

=== flees ===
Ну да. Своей маме еще расскажи. # window:default # char:scout # anim:mocking
Умник! По горшкам дежурник! # char:scout
Разведчик ныряет под теплотрассу. # thought # char:scout # anim:escape # away:scout
// Дальше детектив ищет гостиницу сам. В сценарии эта ветка не прописана.
-> END

=== serious ===
Раз серьезное… # window:default # char:scout # anim:serious
-> walk

=== cuffs ===
Убей не скажу! Вяжи, мент позорный! # char:scout # anim:frantic
Женщина на другой стороне улицы оборачивается на вас с Разведчиком. # thought
Она тычет локтем мужчину с пакетами, идущего рядом с ней. # thought
Этого еще не хватало. # thought
Хорош уже. Перестань визжать. # response # char:detective
Я же не взаправду. # response # char:detective
Будешь знать. # char:scout # anim:smug
А парень не промах. # thought
Блефовать тоже надо уметь. # thought
-> walk

=== walk ===
За снежной крошкой и белым туманом даже соседние дома еле видно. # thought # window:default
Чтобы найти обратный путь до остановки, тебе пришлось бы приложить кучу усилий. # thought
Потеряться в таких условиях легче легкого. # thought
А вот искать что-то или кого-то — уже задача со звездочкой. # thought
Дело будет труднее, чем казалось еще час назад. # thought
Давно у вас погода такая? Не видно ни черта. # response # char:detective
А у нас всю зиму так. # char:scout
А вчера еще хуже стало. # char:scout
Значит, когда Женя приехал, видимость была получше. # thought
Это хорошо. # thought
Остальной путь мы проделали молча. # thought
Вскоре показалась неоновая вывеска «ВИКТОРИЯ», а следом и само коренастое двухэтажное здание. # thought
Пришли. Может, дашь полтос все-таки? # char:scout
Бери, заслужил. # response # char:detective
А если про пацана с фотки чего вспомнишь — заходи на огонек. # response # char:detective
Разведчик выхватывает полтинник и убегает, не попрощавшись. # thought
Брррррррррр! # char:scout # anim:shiver
Он скрывается в тумане, издавая звуки снегохода. # thought # away:scout
Ты с усилием открываешь дверь гостиницы и заходишь внутрь. # thought
-> END
