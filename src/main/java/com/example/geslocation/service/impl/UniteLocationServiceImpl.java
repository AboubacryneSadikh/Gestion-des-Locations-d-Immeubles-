package com.example.geslocation.service.impl;

import com.example.geslocation.dao.ImmeubleDAO;
import com.example.geslocation.dao.UniteLocationDAO;
import com.example.geslocation.dao.impl.ImmeubleDAOImpl;
import com.example.geslocation.dao.impl.UniteLocationDAOImpl;
import com.example.geslocation.model.Immeuble;
import com.example.geslocation.model.UniteLocation;
import com.example.geslocation.service.UniteLocationService;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Implémentation du service pour les opérations liées aux unités de location.
 */
public class UniteLocationServiceImpl implements UniteLocationService {
    
    private final UniteLocationDAO uniteLocationDAO;
    private final ImmeubleDAO immeubleDAO;
    
    /**
     * Constructeur par défaut qui initialise les DAOs.
     */
    public UniteLocationServiceImpl() {
        this.uniteLocationDAO = new UniteLocationDAOImpl();
        this.immeubleDAO = new ImmeubleDAOImpl();
    }
    
    /**
     * Constructeur avec injection de dépendance pour les tests.
     * @param uniteLocationDAO Le DAO des unités de location
     * @param immeubleDAO Le DAO des immeubles
     */
    public UniteLocationServiceImpl(UniteLocationDAO uniteLocationDAO, ImmeubleDAO immeubleDAO) {
        this.uniteLocationDAO = uniteLocationDAO;
        this.immeubleDAO = immeubleDAO;
    }
    
    @Override
    public UniteLocation creer(UniteLocation unite, Long immeubleId) throws Exception {
        // Vérifier si l'immeuble existe
        Optional<Immeuble> optImmeuble = immeubleDAO.findById(immeubleId);
        if (!optImmeuble.isPresent()) {
            throw new Exception("Immeuble non trouvé.");
        }
        
        Immeuble immeuble = optImmeuble.get();
        
        // Définir l'immeuble et la date de création
        unite.setImmeuble(immeuble);
        unite.setDateCreation(new Date());
        
        // Persister l'unité de location
        UniteLocation savedUnite = uniteLocationDAO.create(unite);
        
        // Mettre à jour le nombre d'unités dans l'immeuble
        if (immeuble.getNombreUnites() == null) {
            immeuble.setNombreUnites(1);
        } else {
            immeuble.setNombreUnites(immeuble.getNombreUnites() + 1);
        }
        immeubleDAO.update(immeuble);
        
        return savedUnite;
    }
    
    @Override
    public Optional<UniteLocation> obtenirParId(Long id) {
        return uniteLocationDAO.findById(id);
    }
    
    @Override
    public UniteLocation mettreAJour(UniteLocation unite) throws Exception {
        // Vérifier si l'unité existe
        Optional<UniteLocation> optUnite = uniteLocationDAO.findById(unite.getId());
        if (!optUnite.isPresent()) {
            throw new Exception("Unité de location non trouvée.");
        }
        
        // Conserver l'immeuble et la date de création
        UniteLocation existingUnite = optUnite.get();
        unite.setImmeuble(existingUnite.getImmeuble());
        unite.setDateCreation(existingUnite.getDateCreation());
        
        // Mettre à jour la date de modification
        unite.setDateModification(new Date());
        
        // Mettre à jour l'unité
        return uniteLocationDAO.update(unite);
    }
    
    @Override
    public boolean supprimer(Long id) {
        // Récupérer l'unité
        Optional<UniteLocation> optUnite = uniteLocationDAO.findById(id);
        if (!optUnite.isPresent()) {
            return false;
        }
        
        UniteLocation unite = optUnite.get();
        Immeuble immeuble = unite.getImmeuble();
        
        // Supprimer l'unité
        boolean success = uniteLocationDAO.delete(id);
        
        // Si la suppression a réussi, mettre à jour le nombre d'unités dans l'immeuble
        if (success && immeuble != null && immeuble.getNombreUnites() != null) {
            immeuble.setNombreUnites(immeuble.getNombreUnites() - 1);
            immeubleDAO.update(immeuble);
        }
        
        return success;
    }
    
    @Override
    public List<UniteLocation> obtenirToutes() {
        return uniteLocationDAO.findAll();
    }
    
    @Override
    public List<UniteLocation> obtenirParImmeuble(Long immeubleId) {
        return uniteLocationDAO.findByImmeuble(immeubleId);
    }
    
    @Override
    public List<UniteLocation> obtenirDisponibles() {
        return uniteLocationDAO.findAllAvailable();
    }
    
    @Override
    public List<UniteLocation> obtenirParNombreMinPieces(Integer nombreMinPieces) {
        return uniteLocationDAO.findByNombreMinPieces(nombreMinPieces);
    }
    
    @Override
    public List<UniteLocation> obtenirParPlageLoyer(BigDecimal loyerMin, BigDecimal loyerMax) {
        return uniteLocationDAO.findByLoyerRange(loyerMin, loyerMax);
    }
    
    @Override
    public boolean mettreAJourStatut(Long uniteId, UniteLocation.Statut statut) {
        return uniteLocationDAO.updateStatut(uniteId, statut);
    }
    
    @Override
    public List<UniteLocation> rechercher(Long immeubleId, Integer nombreMinPieces, 
                                        BigDecimal loyerMin, BigDecimal loyerMax, 
                                        Boolean disponible) {
        return uniteLocationDAO.searchByCriteria(immeubleId, nombreMinPieces, loyerMin, loyerMax, disponible);
    }
}