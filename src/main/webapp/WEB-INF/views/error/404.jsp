<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page non trouvée - GesLocation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container-fluid vh-100 d-flex align-items-center justify-content-center bg-light">
    <div class="text-center">
        <div class="mb-4">
            <i class="fas fa-exclamation-triangle fa-5x text-warning"></i>
        </div>
        <h1 class="display-1 fw-bold text-primary">404</h1>
        <h2 class="mb-4">Page non trouvée</h2>
        <p class="lead mb-4">La page que vous recherchez n'existe pas ou a été déplacée.</p>
        <div>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary me-2">
                <i class="fas fa-home me-2"></i>Accueil
            </a>
            <a href="javascript:history.back()" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Retour
            </a>
        </div>
    </div>
</div>
</body>
</html>