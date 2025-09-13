<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>GesLocation - Gestion des Locations d'Immeubles</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background-color: #f8f9fa;
            padding: 4rem 0;
            margin-bottom: 2rem;
        }
        .feature-box {
            padding: 1.5rem;
            border-radius: 5px;
            margin-bottom: 1.5rem;
            background-color: #fff;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            height: 100%;
        }
        .feature-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #0d6efd;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#">GesLocation</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">Accueil</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login">Connexion</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="register">Inscription</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <h1 class="display-4">Gestion des Locations d'Immeubles</h1>
            <p class="lead">Une solution complète pour gérer vos propriétés, locataires et contrats de location</p>
            <div class="d-grid gap-2 d-sm-flex justify-content-sm-center mt-4">
                <a href="register" class="btn btn-primary btn-lg px-4 gap-3">S'inscrire</a>
                <a href="login" class="btn btn-outline-secondary btn-lg px-4">Se connecter</a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="container mb-5">
        <h2 class="text-center mb-4">Fonctionnalités</h2>
        <div class="row">
            <div class="col-md-4">
                <div class="feature-box">
                    <div class="feature-icon">🏢</div>
                    <h3>Gestion des Immeubles</h3>
                    <p>Ajoutez, modifiez et supprimez des immeubles. Gérez les détails comme l'adresse, le nombre d'unités et les équipements disponibles.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box">
                    <div class="feature-icon">🏠</div>
                    <h3>Gestion des Unités</h3>
                    <p>Gérez les unités de location dans vos immeubles avec des détails comme le nombre de pièces, la superficie et le loyer mensuel.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box">
                    <div class="feature-icon">👥</div>
                    <h3>Gestion des Locataires</h3>
                    <p>Inscrivez et gérez les profils des locataires. Permettez-leur de consulter les offres et d'envoyer des demandes de location.</p>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4">
                <div class="feature-box">
                    <div class="feature-icon">📝</div>
                    <h3>Gestion des Contrats</h3>
                    <p>Enregistrez les contrats de location et suivez leur statut. Gérez les dates de début et de fin ainsi que les conditions.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box">
                    <div class="feature-icon">💰</div>
                    <h3>Suivi des Paiements</h3>
                    <p>Suivez les paiements des loyers, générez des reçus et gérez les relances pour les paiements en retard.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box">
                    <div class="feature-icon">📊</div>
                    <h3>Rapports et Statistiques</h3>
                    <p>Générez des rapports sur les locations, les paiements et les utilisateurs pour une meilleure prise de décision.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
        <div class="container text-center">
            <p>&copy; 2023 GesLocation - Tous droits réservés</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
