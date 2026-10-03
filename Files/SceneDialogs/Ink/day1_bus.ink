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
Белая Вязь. Поселок городского типа. # window:default # char:dossier
Входит в Красинский городской округ. Население 3991 человек по данным переписи 1989 года. # char:dossier
Сейчас вдвое меньше. Редкостная дыра. # response # char:detective
Хуже всего то, что я сюда еду не первый раз. # response # char:detective
Основан во время строительства железнодорожной магистрали ГУЛСЖД в 1938 году. # char:dossier
Читай: на костях. # response # char:detective
Вся история поселка связана с заводом Краснефтегаз... # char:dossier
Так-так? # response # char:detective
Который специализируется на производстве оборудования для нефтегазовой области. # char:dossier
И всё? # response # char:detective
И все. # char:dossier
Не густо. Теперь о деле. # response # char:detective
Кто еще связан с делом? # response # char:detective
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
Женя Куликов. 9 лет. # window:default # char:dossier
По словам отца, после ссоры убежал из дома. # char:dossier
Это случилось ровно два дня назад. Предположительно отправился к бабушке в Белую Вязь. # char:dossier
Мобильный оператор косвенно это подтверждает: последний раз сигнал телефона появлялся на полпути к поселку. # char:dossier
Связь и правда говно. # response # char:detective
Стал бы я бумажки перебирать если б ловило. # response # char:detective
Ну спасибо. # char:dossier
-> dossier_menu

=== stepan ===
Отец мальчика. Степан Куликов. Бизнесмен. Твой наниматель. # window:default # char:dossier
Опирается на факты и логику, подмечает ценные детали. # char:dossier
Сильно важничает, но в общем с ним приятно иметь дело. # response # char:detective
Мой основной контакт. # response # char:detective
-> dossier_menu

=== emma ===
Мать мальчика. Эмма Куликова. Бизнесвумен. # window:default # char:dossier
Убита горем и не готова отвечать на вопросы прямо сейчас. # char:dossier
Тем не менее, у тебя есть ее контакт. # char:dossier
Значит, наберем ее позже. # response # char:detective
-> dossier_menu

=== lyudmila ===
Бабушка приехала в город только на следующий день. Она была в отъезде. # window:default # char:dossier
Мальчик вряд ли мог об этом знать. # char:dossier
М-да. Местные менты в курсе? # response # char:detective
Ближайший полицейский участок в Красинске. # char:dossier
Иными словами, местный мент — это ты. # char:dossier
Так я уже не мент. Давненько. # response # char:detective
Сойдешь. # char:dossier
Бабушка мальчика. Людмила Игоревна Куликова. Пенсионерка. Бывшая чиновница. # char:dossier
Надо же с чего-то начинать. # response # char:detective
-> dossier_menu

=== vadim ===
Вадим Титов. Бывший сотрудник Степана Куликова и его контакт в ПГТ. # window:default # char:dossier
Может знать нужных людей и быть в курсе последних событий. # char:dossier
Поинтереснее бабульки будет. # response # char:detective
Обязательно к нему загляну. # response # char:detective
-> dossier_menu

=== semyon ===
Семён Гало. Водитель автобуса. Сменщик того, который сейчас за рулем. # window:default # char:dossier
Судя по табелю с автовокзала именно он вёз Женю в поселок. # char:dossier
А сейчас он где? # response # char:detective
По словам второго водителя — в гостинице. Поругался с женой. # char:dossier
В поселке вряд ли есть вторая гостиница. # response # char:detective
Значит, мы с ним совсем скоро пересечемся. # response # char:detective
-> dossier_menu

=== after_cards ===
Вот карта поселка с отмеченными адресами бабушки и Вадима Титова. # window:default # char:dossier
-> arrival

=== arrival ===
На выход, дядь. # window:default # char:driver # anim:gruff
Приехали, что ли? # response # char:detective
-> END
