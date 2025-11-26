package com.example.facesmash.controller;

import com.example.facesmash.calculate;
import com.example.facesmash.model.Person;
import com.example.facesmash.service.ServicePerson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
public class PersonController {

    @Autowired
    private ServicePerson serv;

    private List<Person> getRandomPair(Long excludeId) {
        Random random = new Random();
        HashSet<Integer> indices = new HashSet<>();

        // Собираем 2 случайных индекса
        while (indices.size() < 2) {
            int randomNumber = random.nextInt(serv.sizeDB());
            if (excludeId == null || randomNumber != excludeId.intValue()) {
                indices.add(randomNumber);
            }
        }

        List<Integer> idxList = new ArrayList<>(indices);
        List<Person> allPersons = serv.getAllPersons();

        // Берём именно 2 персоны по индексам
        List<Person> pair = Arrays.asList(
                allPersons.get(idxList.get(0)),
                allPersons.get(idxList.get(1))
        );

        // Кодируем фото в base64
        pair.forEach(p -> {
            if (p.getPhoto() != null && p.getPhoto().length > 0) {
                String base64 = Base64.getEncoder().encodeToString(p.getPhoto());
                p.setBase64Photo("data:image/jpeg;base64," + base64);
            } else {
                // Если фото нет, подставим заглушку
                p.setBase64Photo("https://via.placeholder.com/300x300.png?text=No+Photo");
            }
        });

        return pair;
    }

    @GetMapping("/pair")
    public List<Person> getPair(@RequestParam(required = false) Long id_win) {
        return getRandomPair(id_win);
    }
    @GetMapping("/")
    public String default(){
        return "Hello its working";
    }

    @PostMapping("/NewElo")
    public void newElo(@RequestParam Long winnerId, @RequestParam Long loserId) {
        int ratingA = serv.getPersonById(winnerId).getElo();
        int ratingB = serv.getPersonById(loserId).getElo();

        int newRatingA = ratingA + ratingB/100*10;
        int newRatingB = ratingB - ratingB/100*10;

        serv.updateRatings(winnerId, newRatingA, loserId, newRatingB);
    }
    @GetMapping("/top")
    public List<Person> getTop(){
        List<Person> peoples = serv.getAllPersons();
        peoples.sort((a, b) -> b.getElo() - a.getElo());
        return peoples;
    }
}
