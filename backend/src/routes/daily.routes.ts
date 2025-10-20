import { Router } from "express";
import { getTodayMeals, getTodayActivities } from "../controllers/daily.controller";
import { validateToken } from "../middlewares/validateToken";
import {
  calculateBMR,
  calculateTargetCalories,
  updateConsumedCalories,
  getCalorieStatus,
} from "../controllers/daily.controller";
import { getDailyMacros } from "../controllers/daily.controller";

const router = Router();

// รายการอาหารของวันปัจจุบัน
router.get("/foods/:userId", validateToken, getTodayMeals);

// รายการกิจกรรมของวันปัจจุบัน
router.get("/sports/:userId", validateToken, getTodayActivities);

// คำนวณหลอด Kcal
router.post("/calculate-bmr/:userId", validateToken, calculateBMR);
router.post("/calculate-target/:userId", validateToken, calculateTargetCalories);
router.post("/update-consumed/:userId", validateToken, updateConsumedCalories);
router.get("/status/:userId", validateToken, getCalorieStatus);
router.get("/macros/:userId", validateToken, getDailyMacros);

export default router;
