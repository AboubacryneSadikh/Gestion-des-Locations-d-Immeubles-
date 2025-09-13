package com.example.geslocation.service;

import com.example.geslocation.model.CandidatureLocation;
import com.example.geslocation.model.ContratLocation;
import com.example.geslocation.model.Paiement;

public interface EmailService {

    /**
     * Envoie une notification d'approbation de candidature au locataire.
     */
    void envoyerNotificationApprobation(CandidatureLocation candidature);

    /**
     * Envoie une notification de refus de candidature au locataire.
     */
    void envoyerNotificationRefus(CandidatureLocation candidature, String motifRefus);

    /**
     * Envoie une notification de création de contrat.
     */
    void envoyerNotificationContrat(ContratLocation contrat);

    /**
     * Envoie une notification de nouvelle candidature au propriétaire.
     */
    void envoyerNotificationNouvelleCandidature(CandidatureLocation candidature);
    // Ajouter ces signatures dans l'interface EmailService

    /**
     * Envoie une notification de résiliation de contrat au locataire.
     * @param contrat Le contrat résilié
     * @param motif Le motif de la résiliation
     * @param commentaire Commentaire supplémentaire (optionnel)
     */
    void envoyerNotificationResiliation(ContratLocation contrat, String motif, String commentaire);

    /**
     * Envoie une notification de renouvellement de contrat au locataire.
     * @param contrat Le contrat renouvelé
     */
    void envoyerNotificationRenouvellement(ContratLocation contrat);

    void envoyerConfirmationPaiement(Paiement paiement);
}