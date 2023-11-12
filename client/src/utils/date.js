import moment from "moment";

function calculateWorkHours(data) {
    // Filter data to get only the current week
    const today = new Date();
    const firstDayOfWeek = new Date(today);
    firstDayOfWeek.setDate(today.getDate() - today.getDay()); // Set to first day of the week

    data = data.filter((item) => {
        const startDate = new Date(item.start);
        return startDate >= firstDayOfWeek && startDate <= today;
    });

    // Convert dates to Date objects
    data.forEach((item) => {
        item.start = new Date(item.start);
        item.end = new Date(item.end);
    });

    // Calculate work hours for each day
    data.forEach((item) => {
        const timeDiff = item.end - item.start;
        const workHours = timeDiff / (1000 * 60 * 60); // Convert milliseconds to hours
        item.workHours = Math.round(workHours * 100) / 100;
    });

    // Calculate total work hours
    const totalWorkHours = data.reduce(
        (total, item) => total + item.workHours,
        0
    );

    // Calculate work percentage
    const hoursPerWeek = 35;
    const workPercentage = (totalWorkHours / (hoursPerWeek * 7)) * 100;
    workingtimes = data;
}

const dateFormat = (dateOrigine) => {
    return moment(dateOrigine).format("D MMMM YYYY, HH:mm:ss");
};

export { calculateWorkHours, dateFormat };