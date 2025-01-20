df <- df_output |>
    filter(cluster >= min_cluster) |>
    # filter(shares >= 0.005) |>  # 0.5%以上のシェアを持つ財のみを残す
    filter(shares >= 0.003) |>  # 3.1%以上のシェアを持つ財のみを残す。これの推定値がいい感じであった。
    # filter(month %in% c(5, 6, 7)) |>
    # filter(month %in% c(3, 4)) |>
    # filter(cluster == 5) |>
    mutate(
        is_airbnb = ifelse(room_type == "Airbnb", 1, 0),
        clustering_ids = paste0(room_type, ":", cluster),
        # clustering_ids = is_airbnb,
        # clustering_ids = cluster,
        # num_of_reviews = log(num_of_reviews + 1),
    )

# a <- df |> filter(room_type == "Airbnb" & month %in% c(5, 6, 7) & shares >= 0.05)
# unique(a$shares)

# if(!only_Airbnb) 
#   df <- df |> filter(shares >= 0.005)  # 0.5%以上のシェアを持つ財のみを残す

if(use_nested_logit){
    df <- df |>
        mutate(
            nesting_ids = paste0(room_type, ":", cluster) # reserved name for PyBLP
            # nesting_ids = cluster # reserved name for PyBLP
            # nesting_ids = is_airbnb,
        )
}

# df_output |>
#     group_by(market_ids) |>
#     summarise(
#         n_airbnb = sum(room_type == "Airbnb", na.rm = TRUE),
#         n_hotel = sum(room_type == "Booking.com", na.rm = TRUE),
#     ) |>
#     View()

# -----------------------------------
# Temporal Manipulation
# -----------------------------------
# df <- df_output |>
#     filter(market_ids == "2024-06-27:sumida:5")



if (only_Airbnb) {
    f_name <- "df_only_airbnb.csv"
} else {
    f_name <- "df_all.csv"
}



write_csv(df, here::here("00_build", "output", f_name))


AP_n <- df |>
    filter(merger_ids == "Airbnb") |>
    nrow()

Airbnb_n <- df |>
    filter(room_type == "Airbnb") |>
    nrow()
AP_ratio <- round(AP_n / Airbnb_n * 100, 3)

print(glue::glue("APを利用するAirbnbホストの割合: {AP_ratio}%"))
print(glue::glue("推定に使用するデータ全体のサンプルサイズ: {nrow(df)}"))
print(glue::glue("filterする前のサンプルサイズ: {nrow(df_output)}"))





