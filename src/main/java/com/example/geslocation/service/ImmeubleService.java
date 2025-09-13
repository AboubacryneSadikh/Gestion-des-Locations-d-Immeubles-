package com.example.geslocation.service;

import com.example.geslocation.model.Immeuble;
import com.example.geslocation.model.UniteLocation;
import java.util.List;
import java.util.Optional;

/**
 * Interface de service pour les opérations liées aux immeubles.
 */
public interface ImmeubleService {
    
    /**
     * Crée un nouvel immeuble.
     * @param immeuble L'immeuble à créer
     * @param proprietaireId L'ID du propriétaire de l'immeuble
     * @return L'immeuble créé avec son ID généré
     * @throws Exception Si la création échoue
     */
    Immeuble creer(Immeuble immeuble, Long proprietaireId) throws Exception;
    
    /**
     * Récupère un immeuble par son ID.
     * @param id L'ID de l'immeuble
     * @return Un Optional contenant l'immeuble si trouvé, sinon un Optional vide
     */
    Optional<Immeuble> obtenirParId(Long id);
    
    /**
     * Met à jour les informations d'un immeuble.
     * @param immeuble L'immeuble avec les informations mises à jour
     * @return L'immeuble mis à jour
     * @throws Exception Si la mise à jour échoue
     */
    Immeuble mettreAJour(Immeuble immeuble) throws Exception;
    
    /**
     * Supprime un immeuble.
     * @param id L'ID de l'immeuble
     * @return true si la suppression a réussi, false sinon
     */
    boolean supprimer(Long id);
    
    /**
     * Récupère tous les immeubles.
     * @return Une liste de tous les immeubles
     */
    List<Immeuble> obtenirTous();
    
    /**
     * Récupère tous les immeubles d'un propriétaire.
     * @param proprietaireId L'ID du propriétaire
     * @return Une liste des immeubles du propriétaire
     */
    List<Immeuble> obtenirParProprietaire(Long proprietaireId);
    
    /**
     * Récupère tous les immeubles dans une ville.
     * @param ville La ville où se trouvent les immeubles
     * @return Une liste des immeubles dans la ville spécifiée
     */
    List<Immeuble> obtenirParVille(String ville);
    
    /**
     * Ajoute une unité de location à un immeuble.
     * @param unite L'unité de location à ajouter
     * @param immeubleId L'ID de l'immeuble
     * @return L'unité de location ajoutée avec son ID généré
     * @throws Exception Si l'ajout échoue
     */
    UniteLocation ajouterUnite(UniteLocation unite, Long immeubleId) throws Exception;
    
    /**
     * Récupère toutes les unités de location d'un immeuble.
     * @param immeubleId L'ID de l'immeuble
     * @return Une liste des unités de location de l'immeuble
     */
    List<UniteLocation> obtenirUnites(Long immeubleId);
    
    /**
     * Recherche des immeubles par critères.
     * @param ville La ville (peut être null)
     * @param nombreMinPieces Le nombre minimum de pièces (peut être null)
     * @param loyerMin Le loyer minimum (peut être null)
     * @param loyerMax Le loyer maximum (peut être null)
     * @return Une liste des immeubles correspondant aux critères
     */
    List<Immeuble> rechercher(String ville, Integer nombreMinPieces, Double loyerMin, Double loyerMax);
    
    /**
     * Compte le nombre total d'unités pour un propriétaire.
     * @param proprietaireId L'ID du propriétaire
     * @return Le nombre total d'unités appartenant au propriétaire
     */
    Long compterUnitesParProprietaire(Long proprietaireId);
}