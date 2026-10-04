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
Ты толстый. # window:default # char:scout # anim:teasing # skippable:false
* [Это чтоб не мерзнуть.]
	Это чтоб не мерзнуть. # response # char:detective # skippable:false
	-> after_fat
* [Не такой уж и толстый.]
	Не такой уж и толстый. # response # char:detective # skippable:false
	-> after_fat
* [А ты чмошник.]
	А ты чмошник. # response # char:detective # skippable:false
	-> after_fat

=== after_fat ===
Скажи лучше, где у вас гостиница? # response # char:detective # skippable:false
Так я тебе прям все и сказал. # char:scout # anim:laugh # skippable:false
Дашь полтос? # char:scout # skippable:false
Сам найду. # response # char:detective # skippable:false
Постой, дядь! Я ж пошутил немножко. # char:scout # skippable:false
Немножко пошутил. Пойдем вместе. # char:scout # skippable:false
Ну веди. # response # char:detective # skippable:false
Как звать-то тебя? # response # char:detective # skippable:false
Я Разведчик. А ты? # char:scout # introduced # skippable:false
Угу. А на самом деле? # response # char:detective # skippable:false
Я на задании. В инкогнито. # char:scout # skippable:false
А тебя? # char:scout # skippable:false
* [Сыщик.]
	Сыщик. # response # char:detective # skippable:false
	~ detective_alias = "scout"
	-> after_name
* [Серега.]
	Серега. # response # char:detective # skippable:false
	~ detective_alias = "serega"
	-> after_name
* [Сергей Степанович.]
	Сергей Степанович. # response # char:detective # skippable:false
	~ detective_alias = "sergey"
	-> after_name

=== after_name ===
А ты чего на остановке стоял? Ждал кого-то? # response # char:detective # skippable:false
{detective_alias == "scout":
	Следил. # char:scout # anim:impressed # skippable:false
- else:
	Следил. # char:scout # anim:nod # skippable:false
}
За кем? # response # char:detective # skippable:false
За обстановкой. # char:scout # skippable:false
Разведчик всегда должен быть начеку. # char:scout # skippable:false
И как обстановка, мгм, на остановке? # response # char:detective # skippable:false
Это засекреченная информация. # char:scout # skippable:false
Тебя не проведешь, я смотрю. # response # char:detective # skippable:false
Угу. # char:scout # anim:stern # skippable:false
А ты зачем приехал? # char:scout # skippable:false
Ищу кое-кого. Ты, кстати, можешь мне помочь. # response # char:detective # skippable:false
Не знаешь вот этого пацана? # response # char:detective # skippable:false
Пока не знаю. # char:scout # anim:blank # skippable:false
И что это значит? # response # char:detective # skippable:false
Пока не скажу. # char:scout # skippable:false
Колись. # response # char:detective # skippable:false
А то что? # char:scout # anim:defiant # skippable:false
* [А то маме расскажу.]
	А то маме расскажу. # response # char:detective # skippable:false
	-> flees
* [Да ничего.]
	Да ничего. # response # char:detective # skippable:false
	Думал, два профессионала смогут найти общий язык, если уж дело серьезное. # response # char:detective # skippable:false
	-> serious
* [А то пойдешь со мной в полицию.]
	А то пойдешь со мной в полицию. # response # char:detective # skippable:false
	Будешь сидеть в наручниках. # response # char:detective # skippable:false
	-> cuffs

=== flees ===
Ну да. Своей маме еще расскажи. # window:default # char:scout # anim:mocking # skippable:false
Умник! По горшкам дежурник! # char:scout # skippable:false
Разведчик ныряет под теплотрассу. # thought # char:scout # anim:escape # away:scout
// Дальше детектив ищет гостиницу сам. В сценарии эта ветка не прописана.
-> END

=== serious ===
Раз серьезное… # window:default # char:scout # anim:serious # skippable:false
-> walk

=== cuffs ===
Убей не скажу! Вяжи, мент позорный! # char:scout # anim:frantic # skippable:false
Женщина на другой стороне улицы оборачивается на вас с Разведчиком. # thought
Она тычет локтем мужчину с пакетами, идущего рядом с ней. # thought
Этого еще не хватало. # thought
Хорош уже. Перестань визжать. # response # char:detective # skippable:false
Я же не взаправду. # response # char:detective # skippable:false
Будешь знать. # char:scout # anim:smug # skippable:false
А парень не промах. # thought
Блефовать тоже надо уметь. # thought
-> walk

=== walk ===
За снежной крошкой и белым туманом даже соседние дома еле видно. # thought # window:default
Чтобы найти обратный путь до остановки, тебе пришлось бы приложить кучу усилий. # thought
Потеряться в таких условиях легче легкого. # thought
А вот искать что-то или кого-то — уже задача со звездочкой. # thought
Дело будет труднее, чем казалось еще час назад. # thought
Давно у вас погода такая? Не видно ни черта. # response # char:detective # skippable:false
А у нас всю зиму так. # char:scout # skippable:false
А вчера еще хуже стало. # char:scout # skippable:false
Значит, когда Женя приехал, видимость была получше. # thought
Это хорошо. # thought
Остальной путь мы проделали молча. # thought
Вскоре показалась неоновая вывеска «ВИКТОРИЯ», а следом и само коренастое двухэтажное здание. # thought
Пришли. Может, дашь полтос все-таки? # char:scout # skippable:false
Бери, заслужил. # response # char:detective # skippable:false
А если про пацана с фотки чего вспомнишь — заходи на огонек. # response # char:detective # skippable:false
Разведчик выхватывает полтинник и убегает, не попрощавшись. # thought
Брррррррррр! # char:scout # anim:shiver # skippable:false
Он скрывается в тумане, издавая звуки снегохода. # thought # away:scout
Ты с усилием открываешь дверь гостиницы и заходишь внутрь. # thought
-> END
