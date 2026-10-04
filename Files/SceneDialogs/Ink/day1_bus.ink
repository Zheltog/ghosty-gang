// День 1. Автобус в Белую Вязь. Детектив читает досье.
// Персонажи: dossier, detective, driver.
// Текст досье — окно default. Окно dossier пустое: только выбор, о ком прочитать.
// Реплики детектива — player_phrase.

# story: bus

VAR seen_zhenya = false
VAR seen_stepan = false
VAR seen_emma = false
VAR seen_lyudmila = false
VAR seen_vadim = false
VAR seen_semyon = false

-> bus

=== bus ===
Белая Вязь. Поселок городского типа. # window:default # char:dossier # skippable:false
Входит в Красинский городской округ. Население 3991 человек по данным переписи 1989 года. # char:dossier # skippable:false
Сейчас вдвое меньше. Редкостная дыра. # response # char:detective # skippable:false
Хуже всего то, что я сюда еду не первый раз. # response # char:detective # skippable:false
Основан во время строительства железнодорожной магистрали ГУЛСЖД в 1938 году. # char:dossier # skippable:false
Читай: на костях. # response # char:detective # skippable:false
Вся история поселка связана с заводом Краснефтегаз... # char:dossier # skippable:false
Так-так? # response # char:detective # skippable:false
Который специализируется на производстве оборудования для нефтегазовой области. # char:dossier # skippable:false
И всё? # response # char:detective # skippable:false
И все. # char:dossier # skippable:false
Не густо. Теперь о деле. # response # char:detective # skippable:false
Кто еще связан с делом? # response # char:detective # skippable:false
-> dossier_menu

=== dossier_menu ===
{seen_zhenya and seen_stepan and seen_emma and seen_lyudmila and seen_vadim and seen_semyon:
	-> after_cards
}
​ # window:dossier
* {not seen_zhenya} [Женя Куликов]
	~ seen_zhenya = true
	-> zhenya
* {not seen_stepan} [Степан Куликов]
	~ seen_stepan = true
	-> stepan
* {not seen_emma} [Эмма Куликова]
	~ seen_emma = true
	-> emma
* {not seen_lyudmila} [Людмила Куликова]
	~ seen_lyudmila = true
	-> lyudmila
* {not seen_vadim} [Вадим Титов]
	~ seen_vadim = true
	-> vadim
* {not seen_semyon} [Семён Гало]
	~ seen_semyon = true
	-> semyon

=== zhenya ===
Женя Куликов. 9 лет. # window:default # char:dossier # skippable:false
По словам отца, после ссоры убежал из дома. # char:dossier # skippable:false
Это случилось ровно два дня назад. Предположительно отправился к бабушке в Белую Вязь. # char:dossier # skippable:false
Мобильный оператор косвенно это подтверждает: последний раз сигнал телефона появлялся на полпути к поселку. # char:dossier # skippable:false
Связь и правда говно. # response # char:detective # skippable:false
Стал бы я бумажки перебирать если б ловило. # response # char:detective # skippable:false
Ну спасибо. # char:dossier # skippable:false
-> dossier_menu

=== stepan ===
Отец мальчика. Степан Куликов. Бизнесмен. Твой наниматель. # window:default # char:dossier # skippable:false
Опирается на факты и логику, подмечает ценные детали. # char:dossier # skippable:false
Сильно важничает, но в общем с ним приятно иметь дело. # response # char:detective # skippable:false
Мой основной контакт. # response # char:detective # skippable:false
-> dossier_menu

=== emma ===
Мать мальчика. Эмма Куликова. Бизнесвумен. # window:default # char:dossier # skippable:false
Убита горем и не готова отвечать на вопросы прямо сейчас. # char:dossier # skippable:false
Тем не менее, у тебя есть ее контакт. # char:dossier # skippable:false
Значит, наберем ее позже. # response # char:detective # skippable:false
-> dossier_menu

=== lyudmila ===
Бабушка приехала в город только на следующий день. Она была в отъезде. # window:default # char:dossier # skippable:false
Мальчик вряд ли мог об этом знать. # char:dossier # skippable:false
М-да. Местные менты в курсе? # response # char:detective # skippable:false
Ближайший полицейский участок в Красинске. # char:dossier # skippable:false
Иными словами, местный мент — это ты. # char:dossier # skippable:false
Так я уже не мент. Давненько. # response # char:detective # skippable:false
Сойдешь. # char:dossier # skippable:false
Бабушка мальчика. Людмила Игоревна Куликова. Пенсионерка. Бывшая чиновница. # char:dossier # skippable:false
Надо же с чего-то начинать. # response # char:detective # skippable:false
-> dossier_menu

=== vadim ===
Вадим Титов. Бывший сотрудник Степана Куликова и его контакт в ПГТ. # window:default # char:dossier # skippable:false
Может знать нужных людей и быть в курсе последних событий. # char:dossier # skippable:false
Поинтереснее бабульки будет. # response # char:detective # skippable:false
Обязательно к нему загляну. # response # char:detective # skippable:false
-> dossier_menu

=== semyon ===
Семён Гало. Водитель автобуса. Сменщик того, который сейчас за рулем. # window:default # char:dossier # skippable:false
Судя по табелю с автовокзала именно он вёз Женю в поселок. # char:dossier # skippable:false
А сейчас он где? # response # char:detective # skippable:false
По словам второго водителя — в гостинице. Поругался с женой. # char:dossier # skippable:false
В поселке вряд ли есть вторая гостиница. # response # char:detective # skippable:false
Значит, мы с ним совсем скоро пересечемся. # response # char:detective # skippable:false
-> dossier_menu

=== after_cards ===
Вот карта поселка с отмеченными адресами бабушки и Вадима Титова. # window:default # char:dossier # skippable:false
-> END
