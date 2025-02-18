-- Create Menu table
create table Used_Ingredients;
CREATE TABLE Menu if not exists (
    id INT PRIMARY KEY,
    menu_date DATE NOT NULL,
    first_course INT REFERENCES Recipe(dish_id),
    second_course INT REFERENCES Recipe(dish_id),
    third_course INT REFERENCES Recipe(dish_id)
);

-- Create Ingredients table
CREATE TABLE Ingredients (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- Create Recipe table
CREATE TABLE Recipe (
    dish_id INT PRIMARY KEY,
    dish_name TEXT NOT NULL
);

-- Create Ingredient_Recipe table
CREATE TABLE Ingredient_Recipe (
    recipe_id INT REFERENCES Recipe(dish_id),
    ingredient_id INT REFERENCES Ingredients(id),
    quantity NUMERIC NOT NULL
);

-- Inserting sample ingredients
INSERT INTO Ingredients (name) VALUES 
('Cucumber'), 
('Yogurt'), 
('Garlic'), 
('Rice'), 
('Chicken'), 
('Tomato'),
('Onion'),
('Olive oil');

-- Inserting sample recipes
INSERT INTO Recipe (dish_id, dish_name) VALUES 
(1, 'Tarator'), 
(2, 'Pile s oriz'), 
(3, 'Chicken and Rice Soup');

-- Inserting ingredients for recipes
INSERT INTO Ingredient_Recipe (recipe_id, ingredient_id, quantity) VALUES 
(1, 1, 200), -- Tarator: 200g of Cucumber
(1, 2, 300), -- Tarator: 300g of Yogurt
(1, 3, 5),   -- Tarator: 5 cloves of Garlic
(2, 4, 200), -- Pile s oriz: 200g of Rice
(2, 5, 300), -- Pile s oriz: 300g of Chicken
(3, 6, 150), -- Chicken and Rice Soup: 150g of Tomato
(3, 7, 50),  -- Chicken and Rice Soup: 50g of Onion
(3, 4, 200), -- Chicken and Rice Soup: 200g of Rice
(3, 5, 300), -- Chicken and Rice Soup: 300g of Chicken
(3, 8, 30);  -- Chicken and Rice Soup: 30g of Olive oil

-- Inserting a sample menu
INSERT INTO Menu (id, menu_date, first_course, second_course, third_course) VALUES
(1, current_date + 1, 1, 2, 3); -- Menu with Tarator, Pile s oriz, Chicken and Rice Soup

-- Recursion query to find the used ingredients and their total quantity
WITH RECURSIVE Used_Ingredients AS (
  -- Base case: get the ingredients for the first dish (first_course)
  SELECT ir.ingredient_id, i.name, ir.quantity
  FROM Ingredient_Recipe ir
  JOIN Ingredients i ON ir.ingredient_id = i.id
  JOIN Recipe r ON ir.recipe_id = r.dish_id
  JOIN Menu m ON m.first_course = r.dish_id
  WHERE m.menu_date = current_date + 1

  UNION ALL

  -- Recursive case: get the ingredients for the second dish (second_course)
  SELECT ir.ingredient_id, i.name, ir.quantity
  FROM Ingredient_Recipe ir
  JOIN Ingredients i ON ir.ingredient_id = i.id
  JOIN Recipe r ON ir.recipe_id = r.dish_id
  JOIN Menu m ON m.second_course = r.dish_id
  WHERE m.menu_date = current_date + 1

  UNION ALL

  -- Recursive case: get the ingredients for the third dish (third_course)
  SELECT ir.ingredient_id, i.name, ir.quantity
  FROM Ingredient_Recipe ir
  JOIN Ingredients i ON ir.ingredient_id = i.id
  JOIN Recipe r ON ir.recipe_id = r.dish_id
  JOIN Menu m ON m.third_course = r.dish_id
  WHERE m.menu_date = current_date + 1
);
-- Final query: sum the quantities of ingredients used across the menu
SELECT name, SUM(quantity) AS total_quantity
FROM Used_Ingredients
GROUP BY name;
