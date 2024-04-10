module task4::finger_guessing_game {

    use std::debug;
    use std::string;
    use sui::clock;
    use sui::clock::Clock;
    use sui::event;

    const Rock: u64 = 0;
    const Scissors: u64 = 1;
    const Paper: u64 = 2;
    const EInvalidGesture: u64 = 0;

    struct GameOutcome has drop, copy {
        player_gesture: u64,
        machine_gesture: u64,
        outcome: string::String
    }

    public fun play(player_gesture: u64, clock: &Clock) {
        // 确保玩家输入在有效范围内
        assert!(player_gesture == Rock || player_gesture == Scissors || player_gesture == Paper, EInvalidGesture);
        let machine_gesture = generate_random_gesture(clock);

        let outcome = if (player_gesture == machine_gesture) {
            string::utf8(b"啊哦，平局。")
        } else {
            if (is_player_wine(player_gesture, machine_gesture)) {
                string::utf8(b"恭喜，你赢了！")
            } else {
                string::utf8(b"遗憾，你输了～")
            }
        };
        string::append(&mut outcome, string::utf8(b"（0：石头，1：剪刀，2：布）"));

        let outcome = GameOutcome {
            player_gesture,
            machine_gesture,
            outcome,
        };

        event::emit(outcome);
    }

    fun generate_random_gesture(clock: &Clock): u64 {
        let timestamp = clock::timestamp_ms(clock);
        let random_value = timestamp % 3;
        debug::print(&random_value);
        random_value
    }

    fun is_player_wine(player_gesture: u64, machine_gesture: u64): bool {
        (player_gesture + 1) % 3 == machine_gesture
    }
}
