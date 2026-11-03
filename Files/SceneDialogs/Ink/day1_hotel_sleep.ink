// День 1. Возвращение в номер. Сон.

# story: hotel_sleep
# save: exit

VAR exit = ""

-> sleep

=== sleep ===
Ты идёшь к себе в номер. # window:default # thought # away:landlady
Буря за окном не утихает. # thought
Похоже, сегодня тебе уже ничего не удастся узнать, надо подождать, пока буран хотя бы позволит видеть, что находится на расстоянии вытянутой руки. # thought
Ты ложишься спать. # thought
~ exit = "night_fire"
-> END
