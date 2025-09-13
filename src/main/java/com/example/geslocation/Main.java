package com.example.geslocation;

import com.example.geslocation.model.Utilisateur;
import com.example.geslocation.util.EntityManagerUtil;
import jakarta.persistence.EntityManager;

import java.util.Date;

public class Main {
    public static void main(String[] args) {
        try {
            System.out.println("🚀 Démarrage de la migration des entités...");

            // On crée un EntityManager pour initialiser les entités
            EntityManager em = EntityManagerUtil.getEntityManager();

            // Si on arrive ici, l'EntityManagerFactory a bien chargé toutes les entités
            System.out.println("✅ Migration effectuée avec succès (les tables ont été créées/mises à jour).");

            em.close();
        } catch (Exception e) {
            System.err.println("❌ Erreur lors de la migration : " + e.getMessage());
            e.printStackTrace();
        } finally {
            EntityManagerUtil.closeEntityManagerFactory();
        }
    }
}
