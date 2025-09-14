# Meal Plan Assistant PRD

## Context
It's difficult to eat healthy in today's world when time is limited and temptations are everywhere (e.g., fast food, delivery apps). Even foods marketed as healthy can contain additives with unexpected side effects.

People need a way to:
- **Plan**: Accurately plan macros (calories, protein, fats, carbs) according to specific goals while accounting for real-life challenges like dining out or busy schedules.
- **Execute**: Buy ingredients, stay within budget, and prep food without wasting time.
- **Monitor**: Track food intake, macros, and adherence in a low-friction way.

## Problem Statement
It's hard to prepare meals that are tasty and effective for achieving goals like fat loss, muscle gain, or lowering cholesterol/inflammation. As a result, people default to convenience over consistency, leading to long-term health risks like obesity, metabolic syndrome, and cardiovascular disease.

## Product Vision
The Meal Plan Assistant will be a single interface to help people proactively manage nutrition. Unlike reactive food tracking apps, this app focuses on planning and execution. It will guide users from setting goals → generating personalized meal plans → buying and preparing food → monitoring progress.

## Core User Persona
- **Age**: 25–40
- **Profile**: Driven, health-conscious professionals
- **Interests**: Performance, longevity, or body composition
- **Tech Familiarity**: Familiar with fitness apps like Apple Health, MyFitnessPal, or Whoop
- **Needs**: Time savings, simplicity, and evidence-based recommendations

## Critical User Journeys

### [create-profile] I want to quickly set up my profile and enter my goals so I can get personalized recommendations without friction.
- [enter-info] I want to enter my height, weight, activity level, and dietary restrictions
- [sync-info] I want to sync bio and tracking data from apps like Apple Health, MyFitnessPal, Oura, or Whoop.

### [set-goals] I want to specify my goals, so I…
- Select at least one goal including lose fat, build muscle, reduce cholesterol/inflammation
- Where relevant, I can choose how aggressively I want to pursue it (e.g., slow vs. fast fat loss based on how many cals under maintenance)

### [set-preferences] I want to add some additional parameters when constructing my meal plan, so I…
- [restrictions] Specify dietary restrictions (e.g., vegan, halal, gluten-free).
- [budget] Set a weekly or monthly grocery budget.
- [cuisine] Define the types of food I like (e.g., Mediterranean, Mexican)
- [timing] Set specific meal timings (e.g., intermittent fasting, no food after 8pm).

### [view-plans] I want to view a full week of meal plans aligned with my goals and preferences, so I…
- [macro-summary] The summary should show the daily macronutrient breakdown and any open spaces for other activities
- [recipe-list] A list of recipes along with total weekly prep/cook time
- [ingredient-list] A list of ingredients along with weekly budget

### [edit-plans] I want to tweak my plan, so I…
- [rotate-recipes] Swap specific meals, ingredients, or adjusting portions.
- [add-events] I want to account for events (e.g., dinner out, travel) so the plan adjusts accordingly.

### [generate-grocery-list] I want to generate a grocery list based on my weekly plan, portion sizes, and number of servings, so I…
- [review-list] Review the list of groceries and budget
- [checkout] Checkout with one click via instaCart or other food delivery

### [track-adherence] I want to track how well I'm following the plan, log how I feel (energy, digestion, etc.), and receive feedback.
- [auto-sync] I want to sync my intake data from MyFitnessPal and compare it to the original plan.

### [get-feedback] I want to see how well I stuck to the plan and get actionable suggestions to improve next week.

## MVP Feature Set

### Core areas:
- Profile setup (manual and Apple Health sync)
- Goal + dietary preference input
- Weekly macro-targeted meal plan generation
- Editable meal plan interface
- Auto-generated grocery list
- Adherence tracking and simple insights

### MVP goals:
- Low time investment to get started
- Plan-first experience (vs track-afterward)
- Easy to follow, budget-aware, and customizable

## Metrics of Success
- % of users completing profile setup
- % of users who view 3+ days of a plan
- % of users who generate a grocery list
- Week-over-week adherence tracking
- % of users reporting progress toward their goals

## Monetization

### Freemium model
- **Free**: 1 profile, 3 plans/week, basic grocery list
- **Premium**: unlimited edits, Instacart export, advanced insights

### Revenue streams
- Subscriptions (monthly/annual)
- Affiliate commissions via grocery delivery (Instacart, Thrive Market)
- Brand partnerships (e.g., supplements, kitchen tools)

---

*This document is a living document and will be updated as requirements evolve and new information becomes available.*
