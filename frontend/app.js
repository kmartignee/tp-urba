document.addEventListener('DOMContentLoaded', () => {
    const apiUrl = '/api';
    const recipeForm = document.getElementById('recipe-form');
    const recipesList = document.getElementById('recipes-list');

    // Charger toutes les recettes au démarrage
    fetchRecipes();

    // Gestionnaire d'événement pour le formulaire
    recipeForm.addEventListener('submit', (e) => {
        e.preventDefault();

        const name = document.getElementById('recipe-name').value;
        const preparation_time = document.getElementById('preparation-time').value;
        const difficulty = document.getElementById('difficulty').value;

        if (name && preparation_time && difficulty) {
            addRecipe({
                name,
                preparation_time,
                difficulty
            });

            // Réinitialiser le formulaire
            recipeForm.reset();
        }
    });

    // Fonction pour récupérer toutes les recettes
    async function fetchRecipes() {
        try {
            const response = await fetch(`${apiUrl}/recipes`);
            const recipes = await response.json();

            // Effacer la liste actuelle
            recipesList.innerHTML = '';

            // Ajouter chaque recette à la liste
            recipes.forEach(recipe => {
                appendRecipeToDOM(recipe);
            });
        } catch (error) {
            console.error('Erreur lors de la récupération des recettes:', error);
        }
    }

    // Fonction pour ajouter une nouvelle recette
    async function addRecipe(recipe) {
        try {
            const response = await fetch(`${apiUrl}/recipes`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(recipe)
            });

            const newRecipe = await response.json();
            appendRecipeToDOM(newRecipe);
        } catch (error) {
            console.error('Erreur lors de l\'ajout de la recette:', error);
        }
    }

    // Fonction pour supprimer une recette
    async function deleteRecipe(id) {
        try {
            await fetch(`${apiUrl}/recipes/${id}`, {
                method: 'DELETE'
            });

            // Supprimer l'élément du DOM
            const recipeElement = document.getElementById(`recipe-${id}`);
            if (recipeElement) {
                recipeElement.remove();
            }
        } catch (error) {
            console.error('Erreur lors de la suppression de la recette:', error);
        }
    }

    // Fonction pour marquer/démarquer une recette comme favorite
    async function toggleFavorite(id, isFavorite) {
        const recipeElement = document.getElementById(`recipe-${id}`);
        const recipeName = recipeElement.querySelector('.recipe-name').textContent;
        const recipeTime = recipeElement.querySelector('.recipe-time').dataset.time;
        const recipeDifficulty = recipeElement.querySelector('.recipe-difficulty').dataset.difficulty;

        try {
            await fetch(`${apiUrl}/recipes/${id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    name: recipeName,
                    preparation_time: recipeTime,
                    difficulty: recipeDifficulty,
                    is_favorite: isFavorite
                })
            });

            // Mettre à jour l'interface
            const favoriteBtn = recipeElement.querySelector('.favorite-btn');
            if (isFavorite) {
                favoriteBtn.classList.add('active');
                favoriteBtn.innerHTML = '★';
            } else {
                favoriteBtn.classList.remove('active');
                favoriteBtn.innerHTML = '☆';
            }
        } catch (error) {
            console.error('Erreur lors de la mise à jour de la recette:', error);
        }
    }

    // Fonction pour ajouter une recette au DOM
    function appendRecipeToDOM(recipe) {
        const li = document.createElement('li');
        li.id = `recipe-${recipe.id}`;
        li.className = 'recipe-item';

        li.innerHTML = `
            <div class="recipe-info">
                <div class="recipe-name">${recipe.name}</div>
                <div class="recipe-meta">
                    <span class="recipe-time" data-time="${recipe.preparation_time}">⏱️ ${recipe.preparation_time} min</span>
                    <span class="recipe-difficulty" data-difficulty="${recipe.difficulty}">🔥 ${recipe.difficulty}</span>
                </div>
            </div>
            <div class="recipe-actions">
                <button class="favorite-btn ${recipe.is_favorite ? 'active' : ''}">${recipe.is_favorite ? '★' : '☆'}</button>
                <button class="delete-btn">🗑️</button>
            </div>
        `;

        // Ajouter les écouteurs d'événements aux boutons
        li.querySelector('.favorite-btn').addEventListener('click', () => {
            toggleFavorite(recipe.id, !recipe.is_favorite);
        });

        li.querySelector('.delete-btn').addEventListener('click', () => {
            deleteRecipe(recipe.id);
        });

        recipesList.appendChild(li);
    }
});