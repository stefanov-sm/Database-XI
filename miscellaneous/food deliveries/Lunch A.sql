-- Създаване на таблица за съставки
--CREATE TABLE IF NOT EXISTS Ingredients (
--    id SERIAL PRIMARY KEY,
--    name TEXT NOT NULL
--);
--
-- Създаване на таблица за рецепти
--CREATE TABLE IF NOT EXISTS Recipe (
--    dish_id INT PRIMARY KEY,
--    dish_name TEXT NOT NULL
--);
--
-- Създаване на таблица за съставки в рецепти (много към много)
--CREATE TABLE IF NOT EXISTS Ingredient_Recipe (
--    recipe_id INT REFERENCES Recipe(dish_id),
--    ingredient_id INT REFERENCES Ingredients(id),
--    quantity NUMERIC NOT NULL
--);
--
-- Създаване на таблица за менюта
--CREATE TABLE IF NOT EXISTS Menu (
--    id INT PRIMARY KEY,
--    menu_date DATE NOT NULL,
--    first_course INT REFERENCES Recipe(dish_id),
--    second_course INT REFERENCES Recipe(dish_id),
--    third_course INT REFERENCES Recipe(dish_id)
--);

-- Вкарване на примерни съставки
--INSERT INTO Ingredients (name) VALUES 
--('Cucumber'), 
--('Yogurt'), 
--('Garlic'), 
--('Rice'), 
--('Chicken'), 
--('Tomato'),
--('Onion'),
--('Olive oil');
--
---- Вкарване на примерни рецепти
----INSERT INTO Recipe (dish_id, dish_name) VALUES 
--(1, 'Tarator'), 
--(2, 'Pile s oriz'), 
--(3, 'Chicken and Rice Soup');

-- Вкарване на съставките за рецептите
--INSERT INTO Ingredient_Recipe (recipe_id, ingredient_id, quantity) VALUES 
--(1, 1, 200),  -- Tarator: 200g от краставица
--(1, 2, 300),  -- Tarator: 300g от кисело мляко
--(1, 3, 5),    -- Tarator: 5 скилидки чесън
--(2, 4, 200),  -- Pile s oriz: 200g от ориз
--(2, 5, 300),  -- Pile s oriz: 300g от пиле
--(3, 6, 150),  -- Chicken and Rice Soup: 150g от домат
--(3, 7, 50),   -- Chicken and Rice Soup: 50g от лук
--(3, 4, 200),  -- Chicken and Rice Soup: 200g от ориз
--(3, 5, 300),  -- Chicken and Rice Soup: 300g от пиле
--(3, 8, 30);   -- Chicken and Rice Soup: 30g от зехтин
--
---- Вкарване на примерен обяд (меню)
--INSERT INTO Menu (id, menu_date, first_course, second_course, third_course) VALUES
--(1, current_date + 1, 1, 2, 3);  -- Меню с Tarator, Pile s oriz, Chicken and Rice Soup

-- Запитване за намиране на използваните съставки и тяхното общо количество за менюто на деня
SELECT 
    i.name,  -- Избиране на името на съставката
    SUM(ir.quantity) AS total_quantity  -- Изчисляване на общото количество на всяка съставка
FROM 
    Menu m
JOIN 
    Recipe r1 ON m.first_course = r1.dish_id  -- Свързване на менюто с първото ястие
JOIN 
    Ingredient_Recipe ir ON r1.dish_id = ir.recipe_id  -- Свързване на рецептата с нейните съставки
JOIN 
    Ingredients i ON ir.ingredient_id = i.id  -- Свързване на съставката по нейните идентификатори
WHERE 
    m.menu_date = current_date + 1  -- Филтриране на менюто за утрешния ден
GROUP BY 
    i.name  -- Групиране по името на съставката, за да се обобщи количеството
UNION ALL  -- Използваме UNION ALL за обединяване на резултатите от следващите два селекта

SELECT 
    i.name, 
    SUM(ir.quantity) AS total_quantity
FROM 
    Menu m
JOIN 
    Recipe r2 ON m.second_course = r2.dish_id  -- Свързване на менюто с второто ястие
JOIN 
    Ingredient_Recipe ir ON r2.dish_id = ir.recipe_id
JOIN 
    Ingredients i ON ir.ingredient_id = i.id
WHERE 
    m.menu_date = current_date + 1
GROUP BY 
    i.name

UNION ALL  -- Продължаваме с обединяването на резултатите за третото ястие

SELECT 
    i.name, 
    SUM(ir.quantity) AS total_quantity
FROM 
    Menu m
JOIN 
    Recipe r3 ON m.third_course = r3.dish_id  -- Свързване на менюто с третото ястие
JOIN 
    Ingredient_Recipe ir ON r3.dish_id = ir.recipe_id
JOIN 
    Ingredients i ON ir.ingredient_id = i.id
WHERE 
    m.menu_date = current_date + 1
GROUP BY 
    i.name;

--select * from ingredients;
