/*
** EPITECH PROJECT, 2023
** rpg [WSL: fedora]
** File description:
** main
*/

#include <SFML/System.h>
#include <stdbool.h>
#include "item.h"
#include "room.h"
#include "entities.h"
#include "errorhandling.h"

bool exit_ecs(sfEvent *event)
{
    if (event->type == sfEvtClosed)
        return true;
    return false;
}

int main(int ac, UNUSED char **av)
{
    window_t *window = NULL;
    item_t *item = NULL;

    if (ac != 1)
        return 84;
    window = window_create((sfVideoMode){1920, 1080, 32}, 60,
            "Into the abyss", (sfFloatRect){0, 0, 1920, 1080});
    item = item_create(item, create_player(window), destroy_player);
    item = item_create(item, gui_create_all(window), gui_destroy_all);
    ASSERT_MALLOC(item, 84);
    item_set_func(item, player_update, NULL, player_print);
    item = item_create(item, init_map(), free_map);
    ASSERT_MALLOC(item, 84);
    item_set_func(item, NULL, NULL, draw_room);
    item_loop(item, window, exit_ecs);
    item_list_destroy(item);
    window_destroy(window);
    return 0;
}
