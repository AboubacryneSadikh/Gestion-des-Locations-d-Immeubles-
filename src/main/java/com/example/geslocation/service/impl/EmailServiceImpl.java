package com.example.geslocation.service.impl;

import com.example.geslocation.model.*;
import com.example.geslocation.service.EmailService;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

public class EmailServiceImpl implements EmailService {

    // Configuration email (à adapter selon votre serveur SMTP)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "etablissementdinformatiqueacad@gmail.com";
    private static final String EMAIL_PASSWORD = "gddpfauhnrpqlcmp";
    private static final String FROM_EMAIL = "noreply@geslocation.com";

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    @Override
    public void envoyerNotificationApprobation(CandidatureLocation candidature) {
        String destinataire = candidature.getLocataire().getUtilisateur().getEmail();
        String sujet = "✅ Candidature approuvée - " + candidature.getUnite().getImmeuble().getNom();

        StringBuilder contenu = new StringBuilder();
        contenu.append("<html><body style='font-family: Arial, sans-serif;'>");
        contenu.append("<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>");
        contenu.append("<h2 style='color: #28a745;'>🎉 Félicitations ! Votre candidature a été approuvée</h2>");

        contenu.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;'>");
        contenu.append("<h3>Détails du logement :</h3>");
        contenu.append("<p><strong>Immeuble :</strong> ").append(candidature.getUnite().getImmeuble().getNom()).append("</p>");
        contenu.append("<p><strong>Unité :</strong> ").append(candidature.getUnite().getNumero()).append("</p>");
        contenu.append("<p><strong>Adresse :</strong> ").append(candidature.getUnite().getImmeuble().getAdresse())
                .append(", ").append(candidature.getUnite().getImmeuble().getVille()).append("</p>");
        contenu.append("<p><strong>Date d'entrée :</strong> ").append(dateFormat.format(candidature.getDateDebutSouhaitee())).append("</p>");
        contenu.append("</div>");

        if (candidature.getCommentaireProprietaire() != null && !candidature.getCommentaireProprietaire().trim().isEmpty()) {
            contenu.append("<div style='background: #e7f5ff; padding: 15px; border-radius: 10px; margin: 20px 0;'>");
            contenu.append("<h4>Message du propriétaire :</h4>");
            contenu.append("<p style='font-style: italic;'>\"").append(candidature.getCommentaireProprietaire()).append("\"</p>");
            contenu.append("</div>");
        }

        contenu.append("<div style='background: #fff3cd; padding: 15px; border-radius: 10px; margin: 20px 0;'>");
        contenu.append("<h4>Prochaines étapes :</h4>");
        contenu.append("<ul>");
        contenu.append("<li>Le propriétaire va préparer le contrat de location</li>");
        contenu.append("<li>Vous recevrez le contrat sous 48h maximum</li>");
        contenu.append("<li>Préparez vos pièces justificatives (revenus, pièce d'identité, etc.)</li>");
        contenu.append("</ul>");
        contenu.append("</div>");

        contenu.append("<div style='text-align: center; margin-top: 30px;'>");
        contenu.append("<p style='color: #6c757d;'>Merci d'avoir choisi notre plateforme de location !</p>");
        contenu.append("</div>");
        contenu.append("</div></body></html>");

        envoyerEmail(destinataire, sujet, contenu.toString());
    }

    @Override
    public void envoyerNotificationRefus(CandidatureLocation candidature, String motifRefus) {
        String destinataire = candidature.getLocataire().getUtilisateur().getEmail();
        String sujet = "Réponse à votre candidature - " + candidature.getUnite().getImmeuble().getNom();

        StringBuilder contenu = new StringBuilder();
        contenu.append("<html><body style='font-family: Arial, sans-serif;'>");
        contenu.append("<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>");
        contenu.append("<h2 style='color: #dc3545;'>Réponse à votre candidature</h2>");

        contenu.append("<p>Nous vous remercions pour l'intérêt porté au logement suivant :</p>");

        contenu.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;'>");
        contenu.append("<p><strong>Immeuble :</strong> ").append(candidature.getUnite().getImmeuble().getNom()).append("</p>");
        contenu.append("<p><strong>Unité :</strong> ").append(candidature.getUnite().getNumero()).append("</p>");
        contenu.append("<p><strong>Adresse :</strong> ").append(candidature.getUnite().getImmeuble().getAdresse())
                .append(", ").append(candidature.getUnite().getImmeuble().getVille()).append("</p>");
        contenu.append("</div>");

        contenu.append("<p>Nous regrettons de vous informer que nous ne pouvons pas donner suite à votre candidature.</p>");

        if (candidature.getCommentaireProprietaire() != null && !candidature.getCommentaireProprietaire().trim().isEmpty()) {
            contenu.append("<div style='background: #f8d7da; padding: 15px; border-radius: 10px; margin: 20px 0;'>");
            contenu.append("<h4>Explication :</h4>");
            contenu.append("<p>").append(candidature.getCommentaireProprietaire()).append("</p>");
            contenu.append("</div>");
        }

        contenu.append("<div style='background: #d1ecf1; padding: 15px; border-radius: 10px; margin: 20px 0;'>");
        contenu.append("<h4>Continuez votre recherche :</h4>");
        contenu.append("<p>N'hésitez pas à consulter nos autres offres de logement qui pourraient mieux correspondre à votre profil.</p>");
        contenu.append("</div>");

        contenu.append("<div style='text-align: center; margin-top: 30px;'>");
        contenu.append("<p style='color: #6c757d;'>Nous vous souhaitons bonne chance dans vos recherches.</p>");
        contenu.append("</div>");
        contenu.append("</div></body></html>");

        envoyerEmail(destinataire, sujet, contenu.toString());
    }

    @Override
    public void envoyerNotificationContrat(ContratLocation contrat) {
        String destinataire = contrat.getLocataire().getUtilisateur().getEmail();
        String sujet = "📋 Votre contrat de location est prêt - " + contrat.getUnite().getImmeuble().getNom();

        StringBuilder contenu = new StringBuilder();
        contenu.append("<html><body style='font-family: Arial, sans-serif;'>");
        contenu.append("<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>");
        contenu.append("<h2 style='color: #28a745;'>🎉 Votre contrat de location est prêt !</h2>");

        contenu.append("<p>Nous avons le plaisir de vous informer que votre contrat de location a été préparé.</p>");

        contenu.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;'>");
        contenu.append("<h3>Informations du contrat :</h3>");
        contenu.append("<p><strong>N° de contrat :</strong> ").append(contrat.getNumeroContrat()).append("</p>");
        contenu.append("<p><strong>Logement :</strong> ").append(contrat.getUnite().getImmeuble().getNom())
                .append(" - Unité ").append(contrat.getUnite().getNumero()).append("</p>");
        contenu.append("<p><strong>Période :</strong> Du ").append(dateFormat.format(contrat.getDateDebut()))
                .append(" au ").append(dateFormat.format(contrat.getDateFin())).append("</p>");
        contenu.append("<p><strong>Loyer mensuel :</strong> ").append(contrat.getLoyer()).append(" €</p>");
        if (contrat.getChargesMensuelles() != null) {
            contenu.append("<p><strong>Charges :</strong> ").append(contrat.getChargesMensuelles()).append(" €</p>");
        }
        contenu.append("<p><strong>Jour de paiement :</strong> Le ").append(contrat.getJourPaiement()).append(" de chaque mois</p>");
        contenu.append("</div>");

        contenu.append("<div style='background: #fff3cd; padding: 15px; border-radius: 10px; margin: 20px 0;'>");
        contenu.append("<h4>Prochaines étapes :</h4>");
        contenu.append("<ul>");
        contenu.append("<li>Contactez le propriétaire pour planifier la signature</li>");
        contenu.append("<li>Préparez les pièces justificatives demandées</li>");
        contenu.append("<li>Prévoyez le versement du dépôt de garantie</li>");
        contenu.append("<li>Souscrivez une assurance habitation</li>");
        contenu.append("</ul>");
        contenu.append("</div>");

        contenu.append("<div style='text-align: center; margin-top: 30px;'>");
        contenu.append("<p style='color: #6c757d;'>Félicitations pour votre nouveau logement !</p>");
        contenu.append("</div>");
        contenu.append("</div></body></html>");

        envoyerEmail(destinataire, sujet, contenu.toString());
    }

    @Override
    public void envoyerNotificationNouvelleCandidature(CandidatureLocation candidature) {
        String destinataire = candidature.getUnite().getImmeuble().getProprietaire().getEmail();
        String sujet = "🔔 Nouvelle candidature reçue - " + candidature.getUnite().getImmeuble().getNom();

        StringBuilder contenu = new StringBuilder();
        contenu.append("<html><body style='font-family: Arial, sans-serif;'>");
        contenu.append("<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>");
        contenu.append("<h2 style='color: #007bff;'>📬 Nouvelle candidature de location</h2>");

        contenu.append("<p>Vous avez reçu une nouvelle candidature pour l'un de vos logements.</p>");

        contenu.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;'>");
        contenu.append("<h3>Logement concerné :</h3>");
        contenu.append("<p><strong>Immeuble :</strong> ").append(candidature.getUnite().getImmeuble().getNom()).append("</p>");
        contenu.append("<p><strong>Unité :</strong> ").append(candidature.getUnite().getNumero()).append("</p>");
        contenu.append("<p><strong>Loyer :</strong> ").append(candidature.getUnite().getLoyer()).append(" €</p>");
        contenu.append("</div>");

        contenu.append("<div style='background: #e7f5ff; padding: 20px; border-radius: 10px; margin: 20px 0;'>");
        contenu.append("<h3>Candidat :</h3>");
        contenu.append("<p><strong>Nom :</strong> ").append(candidature.getLocataire().getUtilisateur().getPrenom())
                .append(" ").append(candidature.getLocataire().getUtilisateur().getNom()).append("</p>");
        contenu.append("<p><strong>Email :</strong> ").append(candidature.getLocataire().getUtilisateur().getEmail()).append("</p>");
        if (candidature.getLocataire().getRevenuMensuel() != null) {
            contenu.append("<p><strong>Revenus :</strong> ").append(candidature.getLocataire().getRevenuMensuel()).append(" €/mois</p>");
        }
        contenu.append("<p><strong>Date d'entrée souhaitée :</strong> ").append(dateFormat.format(candidature.getDateDebutSouhaitee())).append("</p>");
        contenu.append("<p><strong>Durée souhaitée :</strong> ").append(candidature.getDureeBail()).append(" mois</p>");
        contenu.append("</div>");

        if (candidature.getMotivations() != null && !candidature.getMotivations().trim().isEmpty()) {
            contenu.append("<div style='background: #f0f8ff; padding: 15px; border-radius: 10px; margin: 20px 0;'>");
            contenu.append("<h4>Motivations du candidat :</h4>");
            contenu.append("<p style='font-style: italic;'>\"").append(candidature.getMotivations()).append("\"</p>");
            contenu.append("</div>");
        }

        contenu.append("<div style='background: #d4edda; padding: 15px; border-radius: 10px; margin: 20px 0;'>");
        contenu.append("<h4>Action requise :</h4>");
        contenu.append("<p>Connectez-vous à votre espace propriétaire pour examiner cette candidature et prendre une décision.</p>");
        contenu.append("<p><strong>Délai recommandé :</strong> 48 heures maximum</p>");
        contenu.append("</div>");

        contenu.append("<div style='text-align: center; margin-top: 30px;'>");
        contenu.append("<a href='#' style='background: #007bff; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px;'>");
        contenu.append("Voir la candidature</a>");
        contenu.append("</div>");
        contenu.append("</div></body></html>");

        envoyerEmail(destinataire, sujet, contenu.toString());
    }
    // Ajouter ces méthodes dans EmailServiceImpl

    /**
     * Envoie une notification de résiliation de contrat au locataire.
     * @param contrat Le contrat résilié
     * @param motif Le motif de la résiliation
     * @param commentaire Commentaire supplémentaire (optionnel)
     */
    @Override
    public void envoyerNotificationResiliation(ContratLocation contrat, String motif, String commentaire) {
        try {
            String destinataire = contrat.getLocataire().getUtilisateur().getEmail();
            String sujet = "Résiliation de votre contrat de location - " + contrat.getNumeroContrat();

            StringBuilder contenu = new StringBuilder();
            contenu.append("Bonjour ").append(contrat.getLocataire().getUtilisateur().getPrenom())
                    .append(" ").append(contrat.getLocataire().getUtilisateur().getNom()).append(",\n\n");

            contenu.append("Nous vous informons que votre contrat de location n° ")
                    .append(contrat.getNumeroContrat()).append(" a été résilié.\n\n");

            contenu.append("Détails de la résiliation :\n");
            contenu.append("- Propriété : ").append(contrat.getUnite().getImmeuble().getNom())
                    .append(" - Unité ").append(contrat.getUnite().getNumero()).append("\n");
            contenu.append("- Date de résiliation : ").append(formatDate(contrat.getDateFin())).append("\n");
            contenu.append("- Motif : ").append(getMotifLibelle(motif)).append("\n");

            if (commentaire != null && !commentaire.trim().isEmpty()) {
                contenu.append("- Commentaire : ").append(commentaire).append("\n");
            }

            contenu.append("\nVeuillez prendre les dispositions nécessaires pour libérer les lieux ");
            contenu.append("à la date indiquée.\n\n");

            contenu.append("Pour toute question concernant cette résiliation, ");
            contenu.append("n'hésitez pas à nous contacter.\n\n");

            contenu.append("Cordialement,\n");
            contenu.append("L'équipe de gestion immobilière");

            envoyerEmail(destinataire, sujet, contenu.toString());

        } catch (Exception e) {
            System.err.println("Erreur lors de l'envoi de la notification de résiliation : " + e.getMessage());
        }
    }

    /**
     * Envoie une notification de renouvellement de contrat au locataire.
     * @param contrat Le contrat renouvelé
     */
    @Override
    public void envoyerNotificationRenouvellement(ContratLocation contrat) {
        try {
            String destinataire = contrat.getLocataire().getUtilisateur().getEmail();
            String sujet = "Renouvellement de votre contrat de location - " + contrat.getNumeroContrat();

            StringBuilder contenu = new StringBuilder();
            contenu.append("Bonjour ").append(contrat.getLocataire().getUtilisateur().getPrenom())
                    .append(" ").append(contrat.getLocataire().getUtilisateur().getNom()).append(",\n\n");

            contenu.append("Nous avons le plaisir de vous informer que votre contrat de location n° ")
                    .append(contrat.getNumeroContrat()).append(" a été renouvelé.\n\n");

            contenu.append("Nouvelles conditions du contrat :\n");
            contenu.append("- Propriété : ").append(contrat.getUnite().getImmeuble().getNom())
                    .append(" - Unité ").append(contrat.getUnite().getNumero()).append("\n");
            contenu.append("- Nouvelle date de fin : ").append(formatDate(contrat.getDateFin())).append("\n");
            contenu.append("- Loyer mensuel : ").append(formatMontant(contrat.getLoyer())).append("\n");

            if (contrat.getChargesMensuelles() != null &&
                    contrat.getChargesMensuelles().compareTo(BigDecimal.ZERO) > 0) {
                contenu.append("- Charges mensuelles : ").append(formatMontant(contrat.getChargesMensuelles())).append("\n");
            }

            contenu.append("- Jour de paiement : ").append(contrat.getJourPaiement()).append(" de chaque mois\n\n");

            contenu.append("Toutes les autres conditions du contrat restent inchangées.\n\n");

            contenu.append("Nous vous remercions de votre confiance et restons à votre disposition ");
            contenu.append("pour toute question.\n\n");

            contenu.append("Cordialement,\n");
            contenu.append("L'équipe de gestion immobilière");

            envoyerEmail(destinataire, sujet, contenu.toString());

        } catch (Exception e) {
            System.err.println("Erreur lors de l'envoi de la notification de renouvellement : " + e.getMessage());
        }
    }

    /**
     * Convertit un motif de résiliation en libellé lisible.
     * @param motif Le code du motif
     * @return Le libellé correspondant
     */
    private String getMotifLibelle(String motif) {
        if (motif == null) return "Non spécifié";

        switch (motif.toUpperCase()) {
            case "FIN_NORMALE":
                return "Fin normale du contrat";
            case "DEMANDE_LOCATAIRE":
                return "Demande du locataire";
            case "DEMANDE_PROPRIETAIRE":
                return "Demande du propriétaire";
            case "NON_PAIEMENT":
                return "Non-paiement des loyers";
            case "VIOLATION_CONTRAT":
                return "Violation du contrat";
            case "VENTE_BIEN":
                return "Vente du bien immobilier";
            case "AUTRE":
                return "Autre motif";
            default:
                return motif;
        }
    }

    /**
     * Formate un montant en devise locale.
     * @param montant Le montant à formater
     * @return Le montant formaté
     */
    private String formatMontant(BigDecimal montant) {
        if (montant == null) return "0 F CFA";

        java.text.NumberFormat formatter = java.text.NumberFormat.getCurrencyInstance(java.util.Locale.FRANCE);
        String formatted = formatter.format(montant);
        // Remplacer EUR par F CFA pour le contexte sénégalais
        return formatted.replace("EUR", "F CFA").replace("€", "F CFA");
    }

    /**
     * Formate une date au format dd/MM/yyyy.
     * @param date La date à formater
     * @return La date formatée
     */
    private String formatDate(Date date) {
        if (date == null) return "";

        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("dd/MM/yyyy");
        return formatter.format(date);
    }

    /**
     * Méthode utilitaire pour envoyer un email.
     */
    private void envoyerEmail(String destinataire, String sujet, String contenu) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "GesLocation"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinataire));
            message.setSubject(sujet);
            message.setContent(contenu, "text/html; charset=utf-8");

            Transport.send(message);

        } catch (Exception e) {
            // Log l'erreur mais ne pas faire planter l'application
            System.err.println("Erreur lors de l'envoi de l'email à " + destinataire + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
    // Ajouter ces méthodes dans EmailService

    /**
     * Envoie une confirmation de paiement au locataire et au propriétaire.
     * @param paiement Le paiement qui vient d'être effectué
     */
    public void envoyerConfirmationPaiement(Paiement paiement) {
        if (paiement == null || paiement.getContrat() == null ||
                paiement.getContrat().getLocataire() == null ||
                paiement.getContrat().getUnite() == null ||
                paiement.getContrat().getUnite().getImmeuble() == null ||
                paiement.getContrat().getUnite().getImmeuble().getProprietaire() == null) {
            throw new IllegalArgumentException("Données de paiement incomplètes");
        }

        ContratLocation contrat = paiement.getContrat();
        Locataire locataire = contrat.getLocataire();
        UniteLocation unite = contrat.getUnite();
        Immeuble immeuble = unite.getImmeuble();
        Utilisateur proprietaire = immeuble.getProprietaire();

        // Email au locataire
        String sujetLocataire = "Confirmation de paiement - " + immeuble.getNom();
        String corpsLocataire = construireEmailConfirmationLocataire(paiement);

        envoyerEmail(locataire.getUtilisateur().getEmail(), sujetLocataire, corpsLocataire);

        // Email au propriétaire
        String sujetProprietaire = "Paiement reçu - " + immeuble.getNom() + " - Unité " + unite.getNumero();
        String corpsProprietaire = construireEmailConfirmationProprietaire(paiement);

        envoyerEmail(proprietaire.getEmail(), sujetProprietaire, corpsProprietaire);

        System.out.println("Confirmations de paiement envoyées pour le paiement ID: " + paiement.getId());
    }

    /**
     * Construit le contenu de l'email de confirmation pour le locataire.
     */
    private String construireEmailConfirmationLocataire(Paiement paiement) {
        ContratLocation contrat = paiement.getContrat();
        UniteLocation unite = contrat.getUnite();
        Immeuble immeuble = unite.getImmeuble();

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat heureFormat = new SimpleDateFormat("dd/MM/yyyy à HH:mm");
        DecimalFormat montantFormat = new DecimalFormat("#,##0.00 €");

        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>");
        html.append("<html><head><meta charset='UTF-8'></head><body>");
        html.append("<div style='max-width: 600px; margin: 0 auto; font-family: Arial, sans-serif;'>");

        // En-tête
        html.append("<div style='background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>");
        html.append("<h1 style='margin: 0; font-size: 24px;'>✅ Paiement confirmé</h1>");
        html.append("<p style='margin: 10px 0 0 0; opacity: 0.9;'>Votre paiement a été traité avec succès</p>");
        html.append("</div>");

        // Contenu principal
        html.append("<div style='background: white; padding: 30px; border: 1px solid #e9ecef;'>");

        html.append("<h2 style='color: #495057; margin-top: 0;'>Bonjour ").append(contrat.getLocataire().getUtilisateur().getPrenom()).append(",</h2>");
        html.append("<p>Nous vous confirmons que votre paiement de loyer a été reçu et traité avec succès.</p>");

        // Détails du paiement
        html.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        html.append("<h3 style='color: #495057; margin-top: 0;'>Détails du paiement</h3>");
        html.append("<table style='width: 100%; border-collapse: collapse;'>");

        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Référence :</td><td style='padding: 8px 0;'>").append(paiement.getNumeroReference()).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Montant :</td><td style='padding: 8px 0; color: #28a745; font-weight: bold;'>").append(montantFormat.format(paiement.getMontant())).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Date de paiement :</td><td style='padding: 8px 0;'>").append(heureFormat.format(paiement.getDatePaiement())).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Mode de paiement :</td><td style='padding: 8px 0;'>").append(paiement.getMethodePaiement()).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Période :</td><td style='padding: 8px 0;'>").append(new SimpleDateFormat("MM/yyyy").format(paiement.getDateEcheance())).append("</td></tr>");

        html.append("</table>");
        html.append("</div>");

        // Informations du logement
        html.append("<div style='background: #e8f5e8; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        html.append("<h3 style='color: #495057; margin-top: 0;'>Logement concerné</h3>");
        html.append("<p><strong>").append(immeuble.getNom()).append(" - Unité ").append(unite.getNumero()).append("</strong></p>");
        html.append("<p>📍 ").append(immeuble.getAdresse()).append(", ").append(immeuble.getVille()).append("</p>");
        html.append("</div>");

        // Prochaine échéance
        Calendar cal = Calendar.getInstance();
        cal.setTime(paiement.getDateEcheance());
        cal.add(Calendar.MONTH, 1);
        Date prochaineEcheance = cal.getTime();

        html.append("<div style='background: #fff3cd; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #ffc107;'>");
        html.append("<h4 style='color: #856404; margin-top: 0;'>📅 Prochaine échéance</h4>");
        html.append("<p style='margin: 0; color: #856404;'>Votre prochain loyer sera dû le <strong>").append(dateFormat.format(prochaineEcheance)).append("</strong></p>");
        html.append("</div>");

        html.append("<p>Un reçu détaillé est disponible dans votre espace locataire.</p>");
        html.append("<p>Merci pour votre ponctualité !</p>");

        html.append("</div>");

        // Pied de page
        html.append("<div style='background: #f8f9fa; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef; border-top: none;'>");
        html.append("<p style='margin: 0; color: #6c757d; font-size: 14px;'>Cet email est généré automatiquement, merci de ne pas y répondre.</p>");
        html.append("<p style='margin: 5px 0 0 0; color: #6c757d; font-size: 14px;'>© 2024 GesLocation - Gestion immobilière</p>");
        html.append("</div>");

        html.append("</div>");
        html.append("</body></html>");

        return html.toString();
    }

    /**
     * Construit le contenu de l'email de confirmation pour le propriétaire.
     */
    private String construireEmailConfirmationProprietaire(Paiement paiement) {
        ContratLocation contrat = paiement.getContrat();
        Locataire locataire = contrat.getLocataire();
        UniteLocation unite = contrat.getUnite();
        Immeuble immeuble = unite.getImmeuble();

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat heureFormat = new SimpleDateFormat("dd/MM/yyyy à HH:mm");
        DecimalFormat montantFormat = new DecimalFormat("#,##0.00 €");

        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>");
        html.append("<html><head><meta charset='UTF-8'></head><body>");
        html.append("<div style='max-width: 600px; margin: 0 auto; font-family: Arial, sans-serif;'>");

        // En-tête
        html.append("<div style='background: linear-gradient(135deg, #007bff 0%, #6610f2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>");
        html.append("<h1 style='margin: 0; font-size: 24px;'>💰 Paiement reçu</h1>");
        html.append("<p style='margin: 10px 0 0 0; opacity: 0.9;'>Un locataire a effectué son paiement</p>");
        html.append("</div>");

        // Contenu principal
        html.append("<div style='background: white; padding: 30px; border: 1px solid #e9ecef;'>");

        html.append("<h2 style='color: #495057; margin-top: 0;'>Bonjour ").append(immeuble.getProprietaire().getPrenom()).append(",</h2>");
        html.append("<p>Nous vous informons qu'un paiement de loyer vient d'être effectué par votre locataire.</p>");

        // Détails du paiement
        html.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        html.append("<h3 style='color: #495057; margin-top: 0;'>Détails du paiement</h3>");
        html.append("<table style='width: 100%; border-collapse: collapse;'>");

        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Référence :</td><td style='padding: 8px 0;'>").append(paiement.getNumeroReference()).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Montant :</td><td style='padding: 8px 0; color: #28a745; font-weight: bold;'>").append(montantFormat.format(paiement.getMontant())).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Date de paiement :</td><td style='padding: 8px 0;'>").append(heureFormat.format(paiement.getDatePaiement())).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Mode de paiement :</td><td style='padding: 8px 0;'>").append(paiement.getMethodePaiement()).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Période :</td><td style='padding: 8px 0;'>").append(new SimpleDateFormat("MM/yyyy").format(paiement.getDateEcheance())).append("</td></tr>");

        html.append("</table>");
        html.append("</div>");

        // Informations du locataire et du logement
        html.append("<div style='background: #e3f2fd; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        html.append("<h3 style='color: #495057; margin-top: 0;'>Locataire et logement</h3>");
        html.append("<p><strong>Locataire :</strong> ").append(locataire.getUtilisateur().getPrenom()).append(" ").append(locataire.getUtilisateur().getNom()).append("</p>");
        html.append("<p><strong>Logement :</strong> ").append(immeuble.getNom()).append(" - Unité ").append(unite.getNumero()).append("</p>");
        html.append("<p><strong>Adresse :</strong> ").append(immeuble.getAdresse()).append(", ").append(immeuble.getVille()).append("</p>");
        html.append("</div>");

        // Statut des paiements
        html.append("<div style='background: #d4edda; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #28a745;'>");
        html.append("<h4 style='color: #155724; margin-top: 0;'>Statut des paiements</h4>");
        html.append("<p style='margin: 0; color: #155724;'>Ce locataire est à jour dans ses paiements.</p>");
        html.append("</div>");

        html.append("<p>Le paiement sera traité et crédité sur votre compte selon les modalités habituelles.</p>");
        html.append("<p>Vous pouvez consulter le détail de ce paiement dans votre espace propriétaire.</p>");

        html.append("</div>");

        // Pied de page
        html.append("<div style='background: #f8f9fa; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef; border-top: none;'>");
        html.append("<p style='margin: 0; color: #6c757d; font-size: 14px;'>Cet email est généré automatiquement, merci de ne pas y répondre.</p>");
        html.append("<p style='margin: 5px 0 0 0; color: #6c757d; font-size: 14px;'>© 2024 GesLocation - Gestion immobilière</p>");
        html.append("</div>");

        html.append("</div>");
        html.append("</body></html>");

        return html.toString();
    }

    /**
     * Envoie un rappel de paiement au locataire.
     * @param paiement Le paiement en attente ou en retard
     * @throws Exception en cas d'erreur d'envoi
     */
    public void envoyerRappelPaiement(Paiement paiement) throws Exception {
        if (paiement == null || paiement.getContrat() == null ||
                paiement.getContrat().getLocataire() == null) {
            throw new IllegalArgumentException("Données de paiement incomplètes");
        }

        ContratLocation contrat = paiement.getContrat();
        Locataire locataire = contrat.getLocataire();
        UniteLocation unite = contrat.getUnite();
        Immeuble immeuble = unite.getImmeuble();

        String sujet = "Rappel de paiement - " + immeuble.getNom();
        String corps = construireEmailRappelPaiement(paiement);

        envoyerEmail(locataire.getUtilisateur().getEmail(), sujet, corps);

        System.out.println("Rappel de paiement envoyé pour le paiement ID: " + paiement.getId());
    }

    /**
     * Construit le contenu de l'email de rappel de paiement.
     */
    private String construireEmailRappelPaiement(Paiement paiement) {
        ContratLocation contrat = paiement.getContrat();
        UniteLocation unite = contrat.getUnite();
        Immeuble immeuble = unite.getImmeuble();

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        DecimalFormat montantFormat = new DecimalFormat("#,##0.00 €");

        boolean enRetard = paiement.getStatut() == Paiement.Statut.EN_RETARD;

        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>");
        html.append("<html><head><meta charset='UTF-8'></head><body>");
        html.append("<div style='max-width: 600px; margin: 0 auto; font-family: Arial, sans-serif;'>");

        // En-tête
        String couleurHeader = enRetard ? "#dc3545" : "#ffc107";
        html.append("<div style='background: linear-gradient(135deg, ").append(couleurHeader).append(" 0%, #fd7e14 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>");
        html.append("<h1 style='margin: 0; font-size: 24px;'>").append(enRetard ? "⚠️ Paiement en retard" : "📅 Rappel de paiement").append("</h1>");
        html.append("<p style='margin: 10px 0 0 0; opacity: 0.9;'>").append(enRetard ? "Votre loyer est en retard" : "Votre loyer arrive à échéance").append("</p>");
        html.append("</div>");

        // Contenu principal
        html.append("<div style='background: white; padding: 30px; border: 1px solid #e9ecef;'>");

        html.append("<h2 style='color: #495057; margin-top: 0;'>Bonjour ").append(contrat.getLocataire().getUtilisateur().getPrenom()).append(",</h2>");

        if (enRetard) {
            long joursRetard = (System.currentTimeMillis() - paiement.getDateEcheance().getTime()) / (1000 * 60 * 60 * 24);
            html.append("<p>Nous vous informons que votre paiement de loyer est en retard depuis <strong>").append(joursRetard).append(" jour(s)</strong>.</p>");
        } else {
            html.append("<p>Nous vous rappelons que votre paiement de loyer arrive à échéance.</p>");
        }

        // Détails du paiement
        html.append("<div style='background: ").append(enRetard ? "#f8d7da" : "#fff3cd").append("; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid ").append(couleurHeader).append(";'>");
        html.append("<h3 style='color: #495057; margin-top: 0;'>Détails du paiement</h3>");
        html.append("<table style='width: 100%; border-collapse: collapse;'>");

        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Référence :</td><td style='padding: 8px 0;'>").append(paiement.getNumeroReference()).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Montant :</td><td style='padding: 8px 0; color: ").append(couleurHeader).append("; font-weight: bold;'>").append(montantFormat.format(paiement.getMontant())).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Date d'échéance :</td><td style='padding: 8px 0;'>").append(dateFormat.format(paiement.getDateEcheance())).append("</td></tr>");
        html.append("<tr><td style='padding: 8px 0; font-weight: bold;'>Période :</td><td style='padding: 8px 0;'>").append(new SimpleDateFormat("MM/yyyy").format(paiement.getDateEcheance())).append("</td></tr>");

        html.append("</table>");
        html.append("</div>");

        // Informations du logement
        html.append("<div style='background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        html.append("<h3 style='color: #495057; margin-top: 0;'>Logement concerné</h3>");
        html.append("<p><strong>").append(immeuble.getNom()).append(" - Unité ").append(unite.getNumero()).append("</strong></p>");
        html.append("<p>📍 ").append(immeuble.getAdresse()).append(", ").append(immeuble.getVille()).append("</p>");
        html.append("</div>");

        // Instructions de paiement
        html.append("<div style='background: #e8f5e8; padding: 20px; border-radius: 8px; margin: 20px 0;'>");
        html.append("<h3 style='color: #495057; margin-top: 0;'>Comment payer ?</h3>");
        html.append("<p>Vous pouvez effectuer votre paiement directement depuis votre espace locataire :</p>");
        html.append("<div style='text-align: center; margin: 20px 0;'>");
        html.append("<a href='#' style='display: inline-block; background: #28a745; color: white; padding: 12px 30px; text-decoration: none; border-radius: 25px; font-weight: bold;'>Payer maintenant</a>");
        html.append("</div>");
        html.append("<p><strong>Modes de paiement acceptés :</strong></p>");
        html.append("<ul>");
        html.append("<li>Carte bancaire (paiement instantané)</li>");
        html.append("<li>Virement bancaire</li>");
        html.append("<li>Chèque</li>");
        html.append("<li>Espèces (avec reçu)</li>");
        html.append("</ul>");
        html.append("</div>");

        if (enRetard) {
            html.append("<div style='background: #f8d7da; padding: 15px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #dc3545;'>");
            html.append("<h4 style='color: #721c24; margin-top: 0;'>⚠️ Paiement en retard</h4>");
            html.append("<p style='margin: 0; color: #721c24;'>Des frais de retard peuvent s'appliquer conformément à votre contrat de location. Nous vous recommandons de régulariser votre situation rapidement.</p>");
            html.append("</div>");
        }

        html.append("<p>En cas de difficultés, n'hésitez pas à contacter votre propriétaire.</p>");
        html.append("<p>Merci de votre compréhension.</p>");

        html.append("</div>");

        // Pied de page
        html.append("<div style='background: #f8f9fa; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef; border-top: none;'>");
        html.append("<p style='margin: 0; color: #6c757d; font-size: 14px;'>Cet email est généré automatiquement, merci de ne pas y répondre.</p>");
        html.append("<p style='margin: 5px 0 0 0; color: #6c757d; font-size: 14px;'>© 2024 GesLocation - Gestion immobilière</p>");
        html.append("</div>");

        html.append("</div>");
        html.append("</body></html>");

        return html.toString();
    }
}