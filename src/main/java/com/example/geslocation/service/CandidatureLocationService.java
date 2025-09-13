package com.example.geslocation.service;

import com.example.geslocation.model.CandidatureLocation;
import java.util.List;
import java.util.Optional;

public interface CandidatureLocationService {

    /**
     * Crée une nouvelle candidature de location.
     */
    CandidatureLocation creer(CandidatureLocation candidature);

    /**
     * Met à jour une candidature existante.
     */
    CandidatureLocation mettreAJour(CandidatureLocation candidature);

    /**
     * Récupère une candidature par son ID.
     */
    Optional<CandidatureLocation> obtenirParId(Long id);

    /**
     * Récupère toutes les candidatures.
     */
    List<CandidatureLocation> obtenirTous();

    /**
     * Récupère les candidatures d'un propriétaire avec filtre optionnel sur le statut.
     */
    List<CandidatureLocation> obtenirParProprietaire(Long proprietaireId, String statutFilter);

    /**
     * Récupère les candidatures récentes d'un propriétaire avec une limite.
     */
    List<CandidatureLocation> obtenirRecentesParProprietaire(Long proprietaireId, int limite);

    /**
     * Récupère les candidatures d'un locataire.
     */
    List<CandidatureLocation> obtenirParLocataire(Long locataireId);

    /**
     * Récupère les candidatures pour une unité spécifique.
     */
    List<CandidatureLocation> obtenirParUnite(Long uniteId);

    /**
     * Vérifie si un locataire a déjà une candidature en cours pour une unité.
     */
    boolean aCandidatureEnCours(Long locataireId, Long uniteId);

    /**
     * Refuse automatiquement toutes les autres candidatures pour une unité
     * (quand une candidature est acceptée).
     */
    void refuserAutresCandidatures(Long uniteId, Long candidatureApprouveeId, String motifRefus);

    /**
     * Supprime une candidature.
     */
    boolean supprimer(Long id);

    /**
     * Compte le nombre de candidatures par statut pour un propriétaire.
     */
    long compterParProprietaireEtStatut(Long proprietaireId, CandidatureLocation.Statut statut);
}