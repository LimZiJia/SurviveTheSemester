extends GutTest

var component: HealthComponent

func before_each():
	component = HealthComponent.new()
	component.current_health = 100.0
	component.max_health = 100.0



func test_damage():
	component.damage(10.0)
	assert_eq(component.current_health, 90.0)


func test_heal():
	component.current_health = 80.0
	component.heal(10.0)
	assert_eq(component.current_health, 90.0)


func test_heal_percent():
	component.current_health = 75
	component.heal_percent(0.20)
	assert_eq(component.current_health, 95.0)


func test_heal_extra():
	component.heal(1000.0)
	assert_eq(component.current_health, 100.0)


func test_increase_max_health():
	component.increase_max_health(10.0)
	assert_eq(component.max_health, 110.0)


func test_increase_max_health_percent():
	component.increase_max_health_percent(0.1)
	assert_eq(component.max_health, 110.0)
