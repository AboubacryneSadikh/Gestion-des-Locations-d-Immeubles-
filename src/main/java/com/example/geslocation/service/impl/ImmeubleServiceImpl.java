package com.example.geslocation.service.impl;

import com.example.geslocation.dao.ImmeubleDAO;
import com.example.geslocation.dao.UniteLocationDAO;
import com.example.geslocation.dao.UtilisateurDAO;
import com.example.geslocation.dao.impl.ImmeubleDAOImpl;
import com.example.geslocation.dao.impl.UniteLocationDAOImpl;
import com.example.geslocation.dao.impl.UtilisateurDAOImpl;
import com.example.geslocation.model.Immeuble;
import com.example.geslocation.model.UniteLocation;
import com.example.geslocation.model.Utilisateur;
import com.example.geslocation.service.ImmeubleService;

import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * Implémentation du service pour les opérations liées aux immeubles.
 */
public class ImmeubleServiceImpl implements ImmeubleService {
    
    private final ImmeubleDAO immeubleDAO;
    private final UtilisateurDAO utilisateurDAO;
    private final UniteLocationDAO uniteLocationDAO;
    
    /**
     * Constructeur par défaut qui initialise les DAOs.
     */
    public ImmeubleServiceImpl() {
        this.immeubleDAO = new ImmeubleDAOImpl();
        this.utilisateurDAO = new UtilisateurDAOImpl();
        this.uniteLocationDAO = new UniteLocationDAOImpl();
    }
    
    /**
     * Constructeur avec injection de dépendance pour les tests.
     * @param immeubleDAO Le DAO des immeubles
     * @param utilisateurDAO Le DAO des utilisateurs
     * @param uniteLocationDAO Le DAO des unités de location
     */
    public ImmeubleServiceImpl(ImmeubleDAO immeubleDAO, UtilisateurDAO utilisateurDAO, UniteLocationDAO uniteLocationDAO) {
        this.immeubleDAO = immeubleDAO;
        this.utilisateurDAO = utilisateurDAO;
        this.uniteLocationDAO = uniteLocationDAO;
    }
    
    @Override
    public Immeuble creer(Immeuble immeuble, Long proprietaireId) throws Exception {
        // Vérifier si le propriétaire existe
        Optional<Utilisateur> optProprietaire = utilisateurDAO.findById(proprietaireId);
        if (!optProprietaire.isPresent()) {
            throw new Exception("Propriétaire non trouvé.");
        }
        
        Utilisateur proprietaire = optProprietaire.get();
        
        // Vérifier si le propriétaire a le rôle PROPRIETAIRE
        if (proprietaire.getRole() != Utilisateur.Role.PROPRIETAIRE) {
            throw new Exception("L'utilisateur n'est pas un propriétaire.");
        }
        
        // Définir le propriétaire et la date de création
        immeuble.setProprietaire(proprietaire);
        immeuble.setDateCreation(new Date());
        
        // Persister l'immeuble
        return immeubleDAO.create(immeuble);
    }
    
    @Override
    public Optional<Immeuble> obtenirParId(Long id) {
        return immeubleDAO.findById(id);
    }
    
    @Override
    public Immeuble mettreAJour(Immeuble immeuble) throws Exception {
        // Vérifier si l'immeuble existe
        Optional<Immeuble> optImmeuble = immeubleDAO.findById(immeuble.getId());
        if (!optImmeuble.isPresent()) {
            throw new Exception("Immeuble non trouvé.");
        }
        
        // Conserver le propriétaire et la date de création
        Immeuble existingImmeuble = optImmeuble.get();
        immeuble.setProprietaire(existingImmeuble.getProprietaire());
        immeuble.setDateCreation(existingImmeuble.getDateCreation());
        
        // Mettre à jour la date de modification
        immeuble.setDateModification(new Date());
        
        // Mettre à jour l'immeuble
        return immeubleDAO.update(immeuble);
    }
    
    @Override
    public boolean supprimer(Long id) {
        return immeubleDAO.delete(id);
    }
    
    @Override
    public List<Immeuble> obtenirTous() {
        return immeubleDAO.findAll();
    }
    
    @Override
    public List<Immeuble> obtenirParProprietaire(Long proprietaireId) {
        return immeubleDAO.findByProprietaire(proprietaireId);
    }
    
    @Override
    public List<Immeuble> obtenirParVille(String ville) {
        return immeubleDAO.findByVille(ville);
    }
    
    @Override
    public UniteLocation ajouterUnite(UniteLocation unite, Long immeubleId) throws Exception {
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
    public List<UniteLocation> obtenirUnites(Long immeubleId) {
        return uniteLocationDAO.findByImmeuble(immeubleId);
    }
    
    @Override
    public List<Immeuble> rechercher(String ville, Integer nombreMinPieces, Double loyerMin, Double loyerMax) {
        return immeubleDAO.searchByCriteria(ville, nombreMinPieces, loyerMin, loyerMax);
    }
    
    @Override
    public Long compterUnitesParProprietaire(Long proprietaireId) {
        return immeubleDAO.countUnitesForProprietaire(proprietaireId);
    }
}